#!/bin/sh

# author: Andrey V. Kapustin
# email: mail@andreyko.ru


# ******** CONFIG (CHANGES ALLOWED IN THIS SECTION) ********

# paths
etc_nginx="/usr/local/etc/nginx"
etc_apache="/usr/local/etc/apache22/extra"
hosting="/u1/www";

# internal vars
nginx_a="$etc_nginx/sites-available"
nginx_e="$etc_nginx/sites-enabled"
nginx_template="$nginx_a/_template_yii.conf"
apache_a="$etc_apache/sites-available"
apache_e="$etc_apache/sites-enabled"
apache_template="$apache_a/_template_yii.conf"


# ******** INPUT ********

# read input 
read -p "Hostname: " hostname
read -p "Username: " username
stty -echo
read -r -p "FTP password: " password
echo ""
read -r -p "MySQL password: " password_mysql
echo ""
stty echo

# check input
if [ ! "$hostname" ];then
   echo "hostname required!"; exit 1;
fi
if [ ! "$username" ];then
   echo "username required!"; exit 1;
fi
if [ ! "$password" ];then
   echo "FTP password required!"; exit 1;
fi

# ******** CONFIRM ********

read -p "Are you sure [Y/n]?" line
case "$line" in
  y|Y) echo "confirmed"
    ;;
  *) echo "not confirmed";exit 1;;
esac


# ******** FREEBSD USER ********

www="$hosting/$username"

pw useradd $username -d $www -m -h 0 <<EOP
$password
EOP

mkdir "$www/html"
mkdir "$www/log"
mkdir "$www/sessions"
chown -R $username:$username $www


# ******** MYSQL USER ********




# ******** NGINX CONFIG ********

fname="$username.conf"

nginx_conf="$nginx_a/$fname"

# create file
cp $nginx_template $nginx_conf

# replace template
sed -i "" "s/{{hostname}}/${hostname}/g" $nginx_conf
sed -i "" "s/{{username}}/${username}/g" $nginx_conf

# enable
ln -s $nginx_conf "$nginx_e/$fname"
service nginx restart


# ******** APACHE CONFIG ********

apache_conf="$apache_a/$fname"

# create file
cp $apache_template $apache_conf

# replace template
sed -i "" "s/{{hostname}}/${hostname}/g" $apache_conf
sed -i "" "s/{{username}}/${username}/g" $apache_conf

# enable 
ln -s $apache_conf "$apache_e/$fname"
apachectl restart