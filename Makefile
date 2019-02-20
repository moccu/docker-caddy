.PHONY: latest current_tag build_push build push


latest:
	@TAG=latest make build_push

current_tag:
	@TAG=`git describe --tags --abbrev=0` make build_push

build_push:
	@echo About to build and push "${TAG}"; read
	make build push

build:
	docker build -t moccu/caddy:${TAG} -f Dockerfile .
	docker build -t moccu/caddy:${TAG}-dockerproxy -f Dockerfile.dockerproxy .

push:
	docker push moccu/caddy:${TAG}
	docker push moccu/caddy:${TAG}-dockerproxy
