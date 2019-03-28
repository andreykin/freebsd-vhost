#!/bin/sh

sqldump_path=`which mysqldump`
backup_path=/usr/hosting/v1/backup
dst_dir=`date +%y_%m_%d_%H`



for base in `echo "show databases;" | /usr/local/bin/mysql -u root -p{{password}}` ; do



/usr/local/bin/mysqldump -u root -p{{password}} $base | gzip > /backup/bases/$base.$dst_dir.base.gz
del_dir=`date -v-40d +%y_%m_*`
rm /backup/bases/$base.$del_dir

done;



for site in `ls /u1/www/`; do


d=`/bin/date -v-0d +%w`
if  [ "$d" != "0" ]; then
        to_del=`date -v-1d +%y_%m_%d_??`
        rm /backup/files/$site.$to_del.files.tar*
else
        to_del=`date -v-8d +%y_%m_%d_??`
        rm /backup/files/$site.$to_del.files.tar*
fi


tar cfv /backup/files/$site.$dst_dir.files.tar /u1/www/$site/ --exclude=/u1/www/$site/log/ --exclude-tag-all=.exclude_from_backup


done;



tar cfv /backup/conf/$dst_dir.conf.tar /etc/;
for conf in `find \/. -name "*.conf"`; do
tar rfv /backup/conf/$dst_dir.conf.tar $conf;
done;



echo "Done."

chown -R root:wheel /backup
chmod -R 700 /backup
