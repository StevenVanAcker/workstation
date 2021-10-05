cn := workstation-test-env

build:
	docker version
	dpkg -l docker.io
	docker build --build-arg UBUNTUVERSION=$${UBUNTUVERSION:-latest} -t $(cn) .

run:
	docker run --security-opt seccomp=unconfined --rm $(cn) /bin/sh -c '/init.sh && /selftest.sh'

debug:
	docker run --security-opt seccomp=unconfined --rm -ti -v $$PWD/..:/data $(cn) /bin/bash
