.PHONY: latest current_tag build_push build push


preparebuildx:
	DOCKER_CLI_EXPERIMENTAL=enabled docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name multiarchbuilder
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use multiarchbuilder
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx inspect --bootstrap multiarchbuilder

image:
	@echo About to build and push "${TAG}"; read
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --platform linux/arm/v7,linux/amd64 -t moccu/caddy:latest -t moccu/caddy:${TAG} --push .
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx imagetools inspect moccu/caddy:latest
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --platform linux/arm/v7,linux/amd64 -t moccu/caddy:latest-dockerproxy -t moccu/caddy:${TAG}-dockerproxy --build-arg CADDYGO=caddy-dockerproxy.go .
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx imagetools inspect moccu/caddy:latest-dockerproxy
