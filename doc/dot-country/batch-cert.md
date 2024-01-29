## Batch generating or renewing certificates

When you need to generate a small number of certificates for a large number of domains, the script you need is [`batch-multi-certs.js`](https://github.com/polymorpher/ens-registrar-relay/blob/main/script/batch-multi-certs.js). A key distinction between this method and other alternatives are:

1. It operates on the DNS servers directly (as opposed to calling APIs offered by ens-registrar-relay)
2. It does not interact with the blockchain part of the system. As long as the domain is registered and its nameservers are pointed to our systems (ns1.hiddenstate.xyz, ns2.hiddenstate.xyz), the certificate or renewal generation shall be successful. In comparison, API based methods always check the state of registration on the blockchain system, and it only allows renewal when the certificate is about to expire in the next 30 days. 
3. It uses one certificate for multiple domains (currently set to 50), as opposed to one certificate per domain using the APIs or other functions. Since GCP charges $0.1-0.2 per month per certificate under management (along with additional cost from other utilities), this could save considerable costs when we need to manage tens of thousands or more domains.

### Access Control

Since the script interact with DNS servers and their underlying database directly, it should only be run on machine instances with special privileges. Please request for access by raising an issue in this repository with sufficient details for the purpose.

For those who are already granted access, the execution of the script should be performed on the specific GCP instance allocated for the issue.

### Executing the Script

Login to the allocated GCP instance using the usual `gcloud` command and your Google account credentials, then do the following:

```
sudo su worker
cd /opt/ens-registrar-relay
git pull
yarn install
node script/batch-multi-certs.js
```

You should only do this when you need to manually execute the script for some reason, such as to renew for additional domains after customizing the script. Normally, a cron job should automatically execute `/opt/renew.sh`, which should automatically execute the batch renewal script for 1 and 2 letter domains every 2 months.

#### Automatic execution

Setting up the cron job for `worker` account by running `crontab -e` then insert the following line:

```
0 3 1 */2 * /opt/ens-registrar-relay/script/batch-multi-certs.sh
```

(it translates to "At 03:00 on day-of-month 1 in every 2nd month")

Any modified script could have the similar shell-script file created and inserted into crontab. Note that the account for crontab has to be `worker`, since Node.js  and global dependencies are only configured for that account

### Modifying the script

The [current version](https://github.com/polymorpher/ens-registrar-relay/blob/3a0a602df9df074bdfdc56f2d541ac2ed9f0bdae/script/batch-multi-certs.js) of the main loop simply does the following:

1. Enumerate one letter domains (alpha-numerical)
2. Enumerate two letter domains
3. Merge the lists together, remove the domains that are reserved by registry or not already owned (under the web2 registry) by us.
4. Use `batchGenerate` function to generate the certificates for each batch of domains. Currently, the size of batch is set to 50. These certificates will have its id prefixed with `batch-<date>` or a custom value set by environment variable CERT_ID_PREFIX
    - The certificate map-entry of each domain will be updated with the new certificate. If an existing entry exists, it will be removed first
    - By default, wildcard certificates are not generated in this process, unless GENERATE_WILDCARD is set to `true`.
    - Any domain which its root A record does not point to DEFAULT_A_RECORD_IP will be automatically skipped. DEFAULT_A_RECORD_IP defaults to `34.160.72.19`, which is the default "input bar + posts" landing page of all domains after they are purchased)  

Any part of the script can be modified to achieve a new purpose, for example, to renew a list of three-letter premium domains instead of enumerating one and two letter domains, or to remove the A-record check, and verify some CNAME record instead (such as the one used in the recently-developed inscription service)


