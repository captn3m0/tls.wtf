# tls.wtf

We're going to learn everything about tls using openssl.

# Workshop Setup

Run the container using:

```bash
docker run \
--tty --interactive \
--name tls.wtf \
captn3m0/tls.wtf
```

In case you accidentally quit the container, you can login back
to it by running:

```
docker exec -it tls.wtf /bin/ash
```

If you want a clean start:

```
docker stop tls.wtf
docker rm tls.wtf
docker run \
--tty --interactive \
--name tls.wtf \
captn3m0/tls.wtf
```

Make sure you have a recent version of `openssl` before going
any further.

# Part 1: Meet the Cast

_Alice_ and _Bob_ are our regular cast today, and they will help us learn tls.

# Part 2: openssl setup

Start by `openssl version` followed by `openssl help`:

```
$ openssl
OpenSSL> help

Standard commands
asn1parse         ca                ciphers           cms
crl               crl2pkcs7         dgst              dhparam
dsa               dsaparam          ec                ecparam
enc               engine            errstr            exit
gendsa            genpkey           genrsa            help
list              nseq              ocsp              passwd
pkcs12            pkcs7             pkcs8             pkey
pkeyparam         pkeyutl           prime             rand
rehash            req               rsa               rsautl
s_client          s_server          s_time            sess_id
smime             speed             spkac             srp
ts                verify            version           x509

Message Digest commands (see the `dgst' command for more details)
blake2b512        blake2s256        gost              md4
md5               mdc2              rmd160            sha1
sha224            sha256            sha384            sha512

Cipher commands (see the `enc' command for more details)
aes-128-cbc       aes-128-ecb       aes-192-cbc       aes-192-ecb
aes-256-cbc       aes-256-ecb       base64            bf
bf-cbc            bf-cfb            bf-ecb            bf-ofb
camellia-128-cbc  camellia-128-ecb  camellia-192-cbc  camellia-192-ecb
camellia-256-cbc  camellia-256-ecb  cast              cast-cbc
cast5-cbc         cast5-cfb         cast5-ecb         cast5-ofb
des               des-cbc           des-cfb           des-ecb
des-ede           des-ede-cbc       des-ede-cfb       des-ede-ofb
des-ede3          des-ede3-cbc      des-ede3-cfb      des-ede3-ofb
des-ofb           des3              desx              idea
idea-cbc          idea-cfb          idea-ecb          idea-ofb
rc2               rc2-40-cbc        rc2-64-cbc        rc2-cbc
rc2-cfb           rc2-ecb           rc2-ofb           rc4
rc4-40            seed              seed-cbc          seed-cfb
seed-ecb          seed-ofb
```

# Part 3: TLS Basics

- Understand the handshake
- Using `curl`
- Authentication schemes
- PKI and the Web of Trust

## Handshake

This is picked from the RFC2246/TLS1.0 https://tools.ietf.org/html/rfc2246

```
      Client                                               Server

      ClientHello                  -------->
                                                      ServerHello
                                                     Certificate*
                                               ServerKeyExchange*
                                              CertificateRequest*
                                   <--------      ServerHelloDone
      Certificate*
      ClientKeyExchange
      CertificateVerify*
      [ChangeCipherSpec]
      Finished                     -------->
                                               [ChangeCipherSpec]
                                   <--------             Finished
      Application Data             <------->     Application Data
```

# Part 4: Keys, Certificates and everything in between

## Concepts

- Resource Kinds
  - Keys
    - Private Keys
    - Public Keys
  - Certificates
  - Certificate Signing Requests
  - Certificate Chains
- Encoding Schemes
  - ASN.1
- Formatting Schemes
  - PEM
  - DER
- WildCard Entries
  - pkcs\*
  - Java keystore

## Guide

1.  Generate a private key for Alice
2.  Generate a private key for Bob
3.  We'll peek into Alice's private key and learn about PEM vs DER files
4.  Learn a bit more about ASN.1
5.  Generate a self-signed certificate for Bob

This is what you'll need for the above:

- `openssl genrsa --help`
- `openssl rsa --help`
- `openssl x509 --help`
- `openssl req --help`

# Part 5: Lets Encrypt (DEMO)

- PKI Basics and the Web of Trust
- CA Authorities and LetsEncrypt
- Demo using `dehydrated`

# Part 6: `curl` - Our Swiss Army Knife

Curl is a very versatile tool:

```bash
# Download a single file
curl http://path.to.the/file

# Download a file and specify a new filename
curl http://example.com/file.zip -o new_file.zip

# Download multiple files
curl -O URLOfFirstFile -O URLOfSecondFile

# Download all sequentially numbered files (1-24)
curl http://example.com/pic[1-24].jpg

# Download a file and follow redirects
curl -L http://example.com/file

# Download a file and pass HTTP Authentication
curl -u username:password URL

# Download a file with a Proxy
curl -x proxysever.server.com:PORT http://addressiwantto.access

# Download a file from FTP
curl -u username:password -O ftp://example.com/pub/file.zip

# Get an FTP directory listing
curl ftp://username:password@example.com

# Resume a previously failed download
curl -C - -o partial_file.zip http://example.com/file.zip
```

But we are interested in the TLS specific stuff that curl lets us do. Let us make a verbose request to `https//debug.bb8.fun`:

`curl --trace-ascii debug.log https://debug.bb8.fun && nano debug.log`

We'll go through the log and see if we can learn a few things.

Let us now go to the curl man page: https://curl.haxx.se/docs/manpage.html and see if we can figure a few interesting flags.
