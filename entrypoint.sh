#!/bin/bash

export APACHE_RUN_DIR=/tmp/apache2
export APACHE_PID_FILE=${APACHE_RUN_DIR}/apache2.pid
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data

mkdir -p ${APACHE_RUN_DIR}

apache2 -DFOREGROUND
