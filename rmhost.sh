#!/bin/sh

# author: Andrey V. Kapustin
# email: mail@andreyko.ru


# ******** CONFIG (CHANGES ALLOWED IN THIS SECTION ********

# props
. script.properties

# paths
nginx_a="$etc_nginx/sites-available"
nginx_e="$etc_nginx/sites-enabled"
apache_a="$etc_apache/sites-available"
apache_e="$etc_apache/sites-enabled"


# ******** FUNCTIONS ********

usage()
{
    echo "usage: rmhost [ [-f] | [-h] ]"
}

delete_user()
{	
	group_id=$(id -G $username)
	if echo $group_id | egrep -q '^[0-9]+$'; then
		if [ "$to_delete_files" = "1" ]; then
			echo "deleting user and hosting files"
			pw userdel -n $username -u $group_id -r	
		else
			echo "deleting only user"
			pw userdel -n $username -u $group_id
		fi
	else 
		echo "user not found"
		exit
	fi
}

delete_conf()
{
	echo "deleting .conf symlinks"
	rm $apache_e/$username.conf
	rm $nginx_e/$username.conf

	if [ "$to_delete_files" = "1" ]; then
		echo "deleting .conf files"
		rm $apache_a/$username.conf
		rm $nginx_a/$username.conf
	fi

	apachectl graceful
	service nginx restart
}

to_delete_files=0

while [ "$1" != "" ]; do
    case $1 in
        -f | --files )          shift
                                to_delete_files=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


# ******** MAIN ********

# ******** INPUT ********

# read input
read -p "Username: " username

# check input
if [ ! "$username" ];then
   echo "username required!"; exit 1;
fi

# ******** CONFIRM ********

read -p "Are you sure [Y/n]?" line
case "$line" in
  y|Y) echo ""
    ;;
  *) echo "not confirmed";exit 1;;
esac


delete_user
delete_conf
