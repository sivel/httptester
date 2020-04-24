# httptester
HTTP Test container

## Services

* [httpbin](https://httpbin.org)
* [nginx](https://nginx.org)
  * HTTP tcp/80
  * HTTPS tcp/443
  * SNI
  * Invalid SSL
  * Client SSL Cert Auth

## Usage

```
docker run -d --name httptester sivel/httptester
```

The nginx configuration and SSL certificates are built at runtime.

## Configurarion

This container supports 4 env vars to configure it's behavior:

`DEFAULT_SERVER_NAME`
: Hostname of the default nginx server. Default: `default.test`

`SNI1_SERVER_NAME`
: Hostname of the first SNI server. Default: `sni1.default.test`

`SNI2_SERVER_NAME`
: Hostname of the second SNI server. Default: `sni2.default.test`

`FAIL_SERVER_NAME`
: Hostname of the server supporting Invalid SSL due to hostname mismatch. Default: `fail.default.test`

## SSL Cert locations

* `http://DEFAULT_SERVER_NAME/cacert.pem`
* `http://DEFAULT_SERVER_NAME/client.key`
* `http://DEFAULT_SERVER_NAME/client.pem`
