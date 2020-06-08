#!/bin/bash

if [ ! -e /var/lib/mysql/mysql ] ; then
  mysql_install_db --no-defaults --user=mysql
fi

/usr/sbin/mysqld --user=mysql "$@"
