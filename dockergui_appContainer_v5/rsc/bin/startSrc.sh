#!/bin/bash
shellinaboxd -b -t
service ssh start
service docker.io start
sleep 5
chmod 777 /var/run/docker.sock
echo MYSQL_PORT_3306_TCP_ADDR="$MYSQL_PORT_3306_TCP_ADDR" >> /usr/Docker_GUI/gui/mysqlenv
echo MYSQL_PORT_3306_TCP_PORT="$MYSQL_PORT_3306_TCP_PORT" >> /usr/Docker_GUI/gui/mysqlenv
echo MYSQL_ENV_MYSQL_ROOT_PASSWORD="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" >> /usr/Docker_GUI/gui/mysqlenv
echo GITHUB_API_CLIENT_ID="$GITHUB_API_CLIENT_ID" >> /usr/Docker_GUI/gui/mysqlenv
echo GITHUB_API_CLIENT_SECRET="$GITHUB_API_CLIENT_SECRET" >> /usr/Docker_GUI/gui/mysqlenv
chkdbexist=`mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --batch --skip-column-names -e "SHOW DATABASES LIKE 'dockerdb'" | grep dockerdb`
if [ $? -ne 0 ];then
	mysqladmin -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" create dockerdb CHARACTER SET utf8; 
	python /usr/Docker_GUI/gui/manage.pyc syncdb --noinput 
fi
service apache2 start
while true; do echo dockergui_appcontainer; sleep 1; done 
