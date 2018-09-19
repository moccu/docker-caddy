# Caddy Docker Image

Docker image with a customized build of [Caddy](https://github.com/mholt/caddy)

## Features
* Caddy built from source
* DigitalOcean DNS provider
* Telemetry disabled
* Container runs as unprivileged user ([su-exec](https://github.com/ncopa/su-exec))


## Usage

### Run with built-in user
The image comes with a built-in unprivileged user *caddy* (UID 99 / GID 99) which is used by default if the container is started with the `caddy` command. All other commands are run as the container user, which is usually *root* unless started with `--user`.
```
$ docker run moccu/caddy:latest caddy
```
### Run with host user
Caddy can be started with the UID and GID of a host user by setting `$CADDYUID` and `$CADDYGID`. This is the recommended way if certificates have to be mounted into the container.
```
$ id caddy
uid=123(caddy) gid=123(caddy) groups=123(caddy)

$ ls -ln /path/to/certificates
-rw------- 1 123 123 2818 Jan 01 2018 00:00 certificate.pem

$ docker run \
    -e CADDYUID=123 \
    -e CADDYGID=123 \
    -v /path/to/certificates:/certificates:ro \
    moccu/caddy:latest \
    caddy
```
### Run as root
Caddy can be run as *root* although it is not recommended. Therefore `$CADDYUID` and `$CADDYGID` have to be set to `0`.
```
$ docker run -e CADDYUID=0 -e CADDYGID=0 moccu/caddy:latest caddy
```

### Options
#### `$CADDYPATH`
Caddy will use this folder to store assets. The default is `/etc/caddy`.
> Note: Caddy will store Let's Encrypt certificates in a subfolder `acme`.

#### `$CADDYPATH_SETOWNER`
Change owner of `$CADDYPATH` to `$CADDYUID` and `$CADDYGID` if set to `yes` and container is started as `root`. The default is `yes`.

#### `$CADDYUID`
Caddy will be run in the container with this UID. The default is `99`.

#### `$CADDYGID`
Caddy will be run in the container with this GID. The default is `99`.


## Configuration
To configure Caddy, create a configuration file according to the documentation, mount it and start `caddy` with the `-conf` attribute.
```
docker run \
    -v /path/to/Caddyfile:/etc/caddy/Caddyfile:ro \
    moccu/caddy:latest \
    caddy -conf /etc/caddy/Caddyfile
```

## Alternatives
You may want to have a look at the Docker image of Abiola Ibrahim: [abiosoft/caddy](https://hub.docker.com/r/abiosoft/caddy/)
