#! /bin/sh -e

API_PASSWORD=$(cat /run/secrets/$SECRET)

if [ ! -e /etc/nut/.setup ]; then
  if [ -e /etc/nut/local/ups.conf ]; then
    cp /etc/nut/local/ups.conf /etc/nut/ups.conf
  else
    if [ -z "$SERIAL" ]; then
      echo "[${NAME}]" >>/etc/nut/ups.conf
      echo "  driver = ${DRIVER}" >>/etc/nut/ups.conf
      echo "  port = ${PORT}" >>/etc/nut/ups.conf
      echo "  desc = \"${DESCRIPTION}\"" >>/etc/nut/ups.conf
    else
      echo "[${NAME}]" >>/etc/nut/ups.conf
      echo "  driver = ${DRIVER}" >>/etc/nut/ups.conf
      echo "  port = ${PORT}" >>/etc/nut/ups.conf
      echo "  serial = \"${SERIAL}\"" >>/etc/nut/ups.conf
      echo "  desc = \"${DESCRIPTION}\"" >>/etc/nut/ups.conf
    fi
    if [ ! -z "$POLLINTERVAL" ]; then
      echo "        pollinterval = $POLLINTERVAL" >> /etc/nut/ups.conf
    fi
    if [ ! -z "$VENDORID" ]; then
      echo "        vendorid = $VENDORID" >> /etc/nut/ups.conf
    fi
  fi
  if [ -e /etc/nut/local/upsd.conf ]; then
    cp /etc/nut/local/upsd.conf /etc/nut/upsd.conf
  else
    echo "LISTEN 0.0.0.0" >>/etc/nut/upsd.conf
  fi
  if [ -e /etc/nut/local/upsd.users ]; then
    cp /etc/nut/local/upsd.users /etc/nut/upsd.users
  else
    echo "[${API_USER}]" >>/etc/nut/upsd.users
    echo "    password = ${API_PASSWORD}" >> /etc/nut/upsd.users
    echo "    upsmon ${SERVER}" >> /etc/nut/upsd.users
  fi
  if [ -e /etc/nut/local/upsmon.conf ]; then
    cp /etc/nut/local/upsmon.conf /etc/nut/upsmon.conf
  else
    echo "MONITOR ${NAME}@localhost 1 ${API_USER} ${API_PASSWORD} ${SERVER}" >>/etc/nut/upsmon.conf
    echo "RUN_AS_USER ${USER}" >> /etc/nut/upsmon.conf
  fi
  touch /etc/nut/.setup
fi

if [ "${NOTIFYCMD}" != "" ]; then
  chmod +x ${NOTIFYCMD}
  echo "NOTIFYCMD ${NOTIFYCMD}" >> /etc/nut/upsmon.conf
fi

mkdir -m 2750 /dev/shm/nut
chown $USER.$GROUP /dev/shm/nut
[ -e /var/run/nut ] || ln -s /dev/shm/nut /var/run
# Issue #15 - change pid warning message from "No such file" to "Ignoring"
echo 0 > /var/run/nut/upsd.pid && chown $USER.$GROUP /var/run/nut/upsd.pid
echo 0 > /var/run/upsmon.pid

/usr/sbin/upsdrvctl -u root start
/usr/sbin/upsd -u $USER
exec /usr/sbin/upsmon -D