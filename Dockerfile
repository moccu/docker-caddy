FROM golang:latest as builder

ARG version=0.11.0

RUN git clone https://github.com/mholt/caddy -b "v${version}" $GOPATH/src/github.com/mholt/caddy; \
	go get github.com/caddyserver/dnsproviders/digitalocean; \
	go get github.com/caddyserver/builds; \
	cd $GOPATH/src/github.com/mholt/caddy/caddy; \
	sed -i 's|var EnableTelemetry = true|var EnableTelemetry = false|g' caddymain/run.go; \
	sed -i 's|\(\t// This is where other plugins.*\)|\1\n\t_ "github.com/caddyserver/dnsproviders/digitalocean"|g' caddymain/run.go; \
	git checkout -b "moccu"; \
	git -c user.name="moccu" -c user.email="admin@moccu.com"  commit -am "Moccu custom build"; \
	go run build.go; \
	mv caddy /bin/caddy


FROM alpine:latest

ENV CADDYUID=caddy CADDYGID=caddy CADDYPATH=/etc/caddy CADDYPATH_SETOWNER=yes

COPY --from=builder /bin/caddy /usr/bin/caddy
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN addgroup -S -g 99 caddy; \
	adduser -S -D -H -s /sbin/nologin -u 99 -G caddy caddy; \
	chmod 0744 /usr/bin/docker-entrypoint.sh; \
	mkdir -p $CADDYPATH/acme; \
	mkdir -p $CADDYPATH/ocsp; \
	chmod -R 0750 $CADDYPATH; \
	apk add --update --no-cache ca-certificates su-exec libcap; \
	setcap CAP_NET_BIND_SERVICE=+ep /usr/bin/caddy

EXPOSE 80 443
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["caddy"]
