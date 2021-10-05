cn := workstation-test-env

build:
	docker version
	docker build --build-arg UBUNTUVERSION=$${UBUNTUVERSION:-latest} -t $(cn) .

run:
	docker run --rm $(cn) /selftest.sh

debug:
	docker run --rm -ti -v $$PWD/..:/data $(cn) /bin/bash
