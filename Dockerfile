FROM golang:alpine as builder

ARG CADDYGO=caddy.go

ENV GO111MODULE=on

COPY ${CADDYGO} /build/caddy/caddy.go
COPY go.mod /build/caddy/go.mod

RUN set -ex \
	&& apk --update add git \
	&& cd /build/caddy \
	&& go build


FROM alpine:latest

ENV CADDYUID=caddy CADDYGID=caddy CADDYPATH=/etc/caddy CADDYPATH_SETOWNER=yes

COPY --from=builder /build/caddy/caddy /usr/bin/caddy
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN set -ex \
	&& addgroup -S -g 99 caddy \
	&& adduser -S -D -H -s /sbin/nologin -u 99 -G caddy caddy \
	&& chmod 0555 /usr/bin/docker-entrypoint.sh \
	&& mkdir -p $CADDYPATH/acme \
	&& mkdir -p $CADDYPATH/ocsp \
	&& chmod -R 0750 $CADDYPATH \
	&& apk add --update --no-cache ca-certificates su-exec libcap \
	&& setcap CAP_NET_BIND_SERVICE=+ep /usr/bin/caddy

EXPOSE 80 443
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["caddy"]
