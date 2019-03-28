#!/bin/sh
cd /backup/log

for uname in `ls /u1/www/` ; do
    [ -d $uname ] || mkdir $uname
    replace '{uname}' $uname < logrotate.conf > $uname/$uname.conf
    /usr/local/sbin/logrotate -s $uname/logrotate.state $uname/$uname.conf
done;

#/usr/local/sbin/logrotate -s /var/log/www/logrotate.state /var/log/www/rotate.conf
