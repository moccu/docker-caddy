package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"

	// Plugins
	_ "github.com/caddyserver/dnsproviders/digitalocean"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
