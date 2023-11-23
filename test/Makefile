cn := workstation-test-env
opts := --security-opt seccomp=unconfined --rm --hostname ALL

build:
	docker version
	dpkg -l docker.io
	docker build --build-arg UBUNTUVERSION=$${UBUNTUVERSION:-latest} -t $(cn) .

run:
	docker run $(opts) $(cn) /bin/sh -c '/init.sh && /selftest.sh'

debug:
	docker run $(opts) -ti -v $$PWD/..:/data $(cn) /bin/bash
