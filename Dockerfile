FROM alpine:3.17.3
MAINTAINER Mike Nestor <mnestor79@gmail.com>
ARG BUILD_DATE
ARG VCS_REF
ARG NUT_VERSION=2.8.0-r4
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

RUN \
  apk add --update nut=$NUT_VERSION \
  libcrypto1.1 libssl1.1 net-snmp-libs

EXPOSE 3493
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT /usr/local/bin/entrypoint.sh
