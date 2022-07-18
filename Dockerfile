FROM alpine:3.16.1
MAINTAINER Mike Nestor <mnestor79@gmail.com>
ARG BUILD_DATE
ARG VCS_REF
ARG NUT_VERSION=2.7.4-r10
ENV API_USER=upsmon \
  DESCRIPTION=UPS \
  DRIVER=usbhid-ups \
  GROUP=nut \
  NAME=ups \
  POLLINTERVAL= \
  PORT=auto \
  SECRET=nut-upsd-password \
  SERIAL= \
  SERVER=master \
  USER=nut \
  VENDORID=

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
  >>/etc/apk/repositories && \
  apk add --update nut@testing=$NUT_VERSION \
  libcrypto1.1 libssl1.1 net-snmp-libs

EXPOSE 3493
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT /usr/local/bin/entrypoint.sh
