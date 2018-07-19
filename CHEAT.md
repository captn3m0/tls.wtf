# Cheatsheet

-   Don't use this, instead look at the man/help page and figure out yourselves.
-   Don't copy stuff from here, type it instead.

# Openssl

### Generating Keys

```
openssl genrsa -out bob.private.key
```

### Self-Signing

```
openssl req -x509 -key bob.private.key -subj '/CN=bob.server' -out bob.crt
# Without specifying CN:
openssl req -x509 -key bob.private.key -out bob.crt
```

### ASN.1

```
openssl asn1.parse -in <file>
```

# TLS Client Auth

```
cfssl gencsr  -key bob.private.key      csr.json
```

(Be sure to examine the CSR yourselves)

## Signing using cfssl
