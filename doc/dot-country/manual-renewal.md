## Manually renewing the certificate of an external domain

There are some external domains not owned or managed under .country systems, but with its root or subdomain record mapped to .country servers anyway. An example of this is www.harmony.one, which harmony.one redirects to.

The .country system needs to generate and maintain its own version of the certificate for such domain, and made it accessible from the service that is mapped by the domain. In general, it would be sufficient to 

1. create a certificate for such domain
2. add a certificate map entry with such certificate, to the certificate map that is loaded by the mapped services

Alternatively, we can simply update the private key and certificate data of an existing certificate. 

We will use www.harmony.one as an example for an end-to-end walkthrough using the alternative method (updating existing certificate).


Assuming [`certbot`](https://formulae.brew.sh/formula/certbot) is already installed, and your working directory for certificates is `~/certificates`

```
cd ~/certificates
certbot certonly --preferred-challenges http --manual -d "www.harmony.one" --config-dir $(pwd)/config --work-dir $(pwd)/work --logs-dir $(pwd)/logs
```

You will see the following prompt from `stdout`

```
Create a file containing just this data:

<long_string_1>

And make it available on your web server at this URL:

http://www.harmony.one/.well-known/acme-challenge/<long_string_2>
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

Before proceeding, create such file and upload to a special GCP Storage location where certificate HTTP challenges are queried against:

```
cat "<long_string_1>" > <long_string_2>
gsutil cp <long_string_2>  gs://<CERT_BUCKET>/.well-known/http-challenge/
```

Where `<CERT_BUCKET>` is the designated bucket for certificate challenge.

Then, press Enter at the prompt from `certbot`. You should see a success message. If not, review the last few steps and check what went wrong.

```
Successfully received certificate.
Certificate is saved at: .../config/live/www.harmony.one/fullchain.pem
Key is saved at:         .../config/live/www.harmony.one/privkey.pem
This certificate expires on ....
These files will be updated when the certificate renews.
```

Now, update the existing certificate for www.harmony.one at GCP:

```
gcloud certificate-manager certificates update <CERT_NAME> --certificate-file=$(pwd)/config/live/www.harmony.one/fullchain.pem --private-key-file="$(pwd)/config/live/www.harmony.one/privkey.pem" --project=<PROJECT>
```

Where `<CERT_NAME>` and `<PROJECT>` can be obtained from the admin

