#!/bin/sh

# author: Andrey V. Kapustin
# email: mail@andreyko.ru

# ********* CHECK SYMLINK ********
DIR="$(dirname "$(readlink -f "$0")")"


# ******** CONFIG (CHANGES ALLOWED IN THIS SECTION) ********

# paths
. $DIR/script.properties

# internal vars
nginx_a="$etc_nginx/sites-available"
nginx_e="$etc_nginx/sites-enabled"
nginx_template="$DIR/templates/_template_yii_nginx.conf"
apache_a="$etc_apache/sites-available"
apache_e="$etc_apache/sites-enabled"
apache_template="$DIR/templates/_template_yii_apache.conf"
logrotate_template="$DIR/templates/_logrotate_www.conf"


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
mkdir "$www/tmp"
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
sed -i "" 's|{{hosting}}|'$hosting'|g' $nginx_conf
sed -i "" 's|{{nginx_listen}}|'$nginx_listen'|g' $nginx_conf
sed -i "" 's|{{apache_listen}}|'$apache_listen'|g' $nginx_conf

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
sed -i "" 's|{{hosting}}|'$hosting'|g' $apache_conf
sed -i "" 's|{{email}}|'$email'|g' $apache_conf
sed -i "" 's|{{apache_listen}}|'$apache_listen'|g' $apache_conf

# enable 
ln -s $apache_conf "$apache_e/$fname"
apachectl restart

# ******** LOGROTATE CONFIG ********

logrotate_conf="$etc_logrotate/www_$username"

# create file
cp $logrotate_template $logrotate_conf

# replace template
sed -i "" "s/{{username}}/${username}/g" $logrotate_conf
sed -i "" 's|{{hosting}}|'$hosting'|g' $logrotate_conf

# run first time
logrotate -f $logrotate_conf