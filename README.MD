# FreeBSD "add virtual host" shell script with config and templates

## WARNING ##
This code is not fully ready for production, at the moment only application templates are of interest. Run the script at your own risk. Read the source code carefully and adapt it to your application.

This basic script:
- promt $hostname, $username and $password;
- add FreeBSD user with given $username and $password;
- create apache and nginx `$username.conf` in `sites-available` from templates with `{{username}}` and `{{hostname}}` and other placeholders;
- create `sites-enabled` symlinks;
- restart

[Templates](templates) folder incuded apache and nginx templates for my favorite yii1 php framework, you feel change it as you like.

## Usage 

### First time
1. Modify [script.properties](script.properties) according to your configuration (I use `/u1/www` for host files locations):
    - If you use Apache 2.4 instead of Apache 2.2 version, change `apache22` to `apache24`
1. Edit [_template_yii_apache](templates/_template_yii_apache.conf)  and [_template_yii_nginx](templates/_template_yii_nginx.conf) conf files. Use `{{username}}` and `{{hostname}}` placeholders for username and hostname. Also you may use some values from properties file;
1. Modify your apache config file to use new directory structure:

for Apache 2.2:
```shell
mkdir /usr/local/etc/apache22/extra/sites-available;
mkdir /usr/local/etc/apache22/extra/sites-enabled;
echo 'Include etc/apache22/extra/sites-enabled/*.conf' >> /usr/local/etc/apache22/extra/httpd-vhosts.conf;
```
for Apache 2.4:
```shell
mkdir /usr/local/etc/apache24/extra/sites-available;
mkdir /usr/local/etc/apache24/extra/sites-enabled;
echo 'Include etc/apache24/extra/sites-enabled/*.conf' >> /usr/local/etc/apache24/extra/httpd-vhosts.conf;
```

### Every time
```shell
# for adding host
sh vhost.sh
# for deleteting host (removes user and disable config files)
sh rmhost.sh
# for deleteting with file removal
sh rmhost.sh -f
```
or (after adding symlink to /usr/sbin)
```shell
# for adding host
vhost
# for deleteting host (removes user and disable config files)
rmhost
# for deleteting with file removal
rmhost -f
```

## TODO:
- add custom template names;
- add some validation rules;
- add php-fmp;
- add mysql;
