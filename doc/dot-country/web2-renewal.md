## Renew domains at the registrar

The web2 .country domains are separated into three groups:

1) Domains registered prior to September 27, 2023, when the standard registration price is raised to $2000
2) Premium domains as defined by the registry in multiple tiers, which often include popular keywords, such as `money.country`
3) Non-premium domains registered on or after September 27, 2023

Premium domains must be renewed by registry operations instead of at the registrar. Therefore, renewing premium domains cannot be done by automated scripts at our side (dot-country servers or admin scripts as described in this document). All such renewal requests need to be sent manually to the contact at the registry.

There was a TLD-wide registration and renewal price adjustment on September 27, 2023. As a result, all domains in group (1) are also classified as "premium" for the purpose of pricing at the registrar via automated operations (such as via APIs).

Therefore, only domains in group (3) can be renewed via scripts and APIs. To assist with drafting renewal requests for registry operations, we prepared some scripts here to enumerate the domains in group (1) and (2).

### Renewal via API

This can be done at the usual ens-registrar-relay server (`https://1ns-registrar-relayer.hiddenstate.xyz`), or at any other forked server with the correct credentials.

```
POST /renew
{
    "domain": "<domain_name>.country"
}
```

The API requires the domain's expiration date on-chain is no earlier than the web2 expiration date on the registrar. This restriction ensures someone indeed owns the domain on-chain, and has already paid the price on-chain to cover the cost of operations on the domain in the registrar.

If the domain is a web2 premium domain, or is owned by someone else in web2, the call would fail. Otherwise, the domain would be renewed at the registrar for another 1 year from its expiration date. The operation will be logged in the datastore. The old expiration time would be returned in the response along with some other information in JSON:

- **success**: boolean
- **domainCreationTime**: number, unix time in milliseconds, when the domain was registered
- **domainExpiryTime**: number,  unix time in milliseconds, when the domain was set to expire prior to the renewal
- **duration**: number, how many years the domain is renewed
- **responseText**: string, additional response from the registrar, if any
- **traceId**: string, an id for registrar operation, useful for debugging or filing support ticket if something goes wrong

### Renewal via scripts

The [script](https://github.com/polymorpher/ens-registrar-relay/blob/main/script/renew-web2.js) looks up for all domains expiring under our management at the web2 registrar, classify the domains based on their groups, renew all non-premium domains (group 3), and report the classifications in stdout.

You may also specify some particular domains to be renewed, instead of looking up all expiring domains. To do that, set `DOMAIN_LIST` to a JSON array of strings, where each element is the domain to be renewed.

Only Namecheap registrar is supported at this time. To use, simply run `node script/renew-web2.js`. You will need at least the following environment variables configured in `.env`:

```
NAMECHEAP_API_USER=
NAMECHEAP_USERNAME=
NAMECHEAP_DEFAULT_IP=
NAMECHEAP_LIVE=
NAMECHEAP_API_KEY=
```

#### Lookup-only mode

To use this mode, set `LOOKUP_ONLY` environment variable to `true`, In this mode, no renewal at the registrar would be performed. The script simply looks up all expiring domains, classify the domains, and print the results in stdout.

#### Modifying the script

The script excludes domains starting with `testtest` and `francisco`, and any domain longer than 15 characters in length. They were historically used to do end-to-end test purchases in production. You may adjust the filter in your modified script.


