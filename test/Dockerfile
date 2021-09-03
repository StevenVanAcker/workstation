ARG UBUNTUVERSION=latest
FROM ubuntu:$UBUNTUVERSION
ARG UBUNTUVERSION=latest

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Building docker container in ubuntu:$UBUNTUVERSION"
COPY init.sh /init.sh
RUN /init.sh
COPY selftest.sh /selftest.sh

