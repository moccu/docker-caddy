#!/usr/bin/env sh
set -e

# If container is run as root, start caddy as unprivileged
# user defined in $CADDYUID and $CADDYGID.
# Defaults to caddy:caddy (99:99).
if [ "$1" == 'caddy' ] && [ "$(id -u)" == '0' ]; then
	if [ "$CADDYPATH_SETOWNER" == 'yes' ]; then
		chown "$CADDYUID:$CADDYGID" "$CADDYPATH"
		chown "$CADDYUID:$CADDYGID" "$CADDYPATH/acme"
		chown "$CADDYUID:$CADDYGID" "$CADDYPATH/ocsp"
	fi
	exec su-exec "$CADDYUID:$CADDYGID" "$@"
fi

exec "$@"
