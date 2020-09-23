#!/bin/bash

export APACHE_RUN_DIR=/tmp/apache2
export APACHE_PID_FILE=${APACHE_RUN_DIR}/apache2.pid
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_FCGID_SOCK_DIR=/tmp/fcgid-sock

export APACHE_DOCUMENT_ROOT=/var/www/html

mkdir -p ${APACHE_RUN_DIR}

# 
mkdir -p ${APACHE_FCGID_SOCK_DIR}
chown www-data.www-data ${APACHE_FCGID_SOCK_DIR}

# 
if [ -e /opt/mt-config/mt-config.cgi ]; then
  echo "[entrypoint.sh] mt-config.cgi found."
  cp /opt/mt-config/mt-config.cgi ${APACHE_DOCUMENT_ROOT}/mt-config.cgi
fi

chown -R ${APACHE_RUN_USER}.${APACHE_RUN_GROUP} ${APACHE_DOCUMENT_ROOT}/mt-config.cgi
chmod 755 /var/www/html/mt-config.cgi

exec apache2 -DFOREGROUND
