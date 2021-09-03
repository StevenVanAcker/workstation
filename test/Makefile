cn := workstation-test-env

build:
	docker build -t $(cn) .

run:
	docker run --rm -ti $(cn) /selftest.sh

debug:
	docker run --rm -ti -v $$PWD/..:/data $(cn) /bin/bash
