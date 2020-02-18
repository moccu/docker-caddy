package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	// Plugins
	_ "github.com/caddyserver/dnsproviders/digitalocean"
	_ "github.com/lucaslorentz/caddy-docker-proxy/plugin"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
