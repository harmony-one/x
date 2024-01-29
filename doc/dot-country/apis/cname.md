# CNAME

Set CNAME record for a subdomain. Requires domain owner's signature for authentication

```
POST /cname
{
    "domain": "zeroknowledge.country",
    "subdomain": "abc",
    "targetDomain": "dev.hiddenstate.xyz",
    "signature": "0x5cf683ff16f19a8e72d025449c6b36506fcf42b2710268c8c15b15badb9f3bfd757b6c54aec11786ac5d09a037874a297a6ad578f5cebdcff17e7d5d1f9a55201b",
    "deadline": 1686396088
}
```

where:

- `deadline` is unix epoch in seconds
- `signature` is the signature of the Ethereum signed message in the form of `I want to map subdomain abc.zeroknowledge.country to dev.hiddenstate.xyz. This operation has to complete by timestamp 1686396088`
- an optional field `deleteRecord` can be used to delete the subdomain CNAME

Response:

- 200 Success: `{"success": true}`
- 400 Bad Request: `{"errors": ... }` for bad requests failing basic validation
- Other errors: `{"error": "..."}` (including other types of 400 Bad Request)

If `deleteRecord` is used, the message to sign becomes: `I want to delete subdomain mapping for ${subdomain}.${sld}.country. This operation has to complete by timestamp ${deadline}`