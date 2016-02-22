# FreeBSD "add virtual host" shell script

This basic script:
- promt $hostname, $username and $password;
- add FreeBSD user with given $username and $password;
- create apache and nginx `$username.conf` in `sites-available` from `templates` with `{{username}}` and `{{hostname}}` and other placeholders;
- create `sites-enabled` symlinks;
- restart

Templates folder incuded apache and nginx templates for my favorite yii1 php framework, you feel free change it as you like.

## Usage 

### First time
1. Edit `script.properties` to adapt paths according to your configuration (I use `/u1/www` for host files locations):
    - If you use Apache 2.4 instead of Apache 2.2 version, change `apache22` to `apache24`
1. Edit `_template_yii_*.conf` template files. Use `{{username}}` and `{{hostname}}` placeholders for username and hostname values;
1. Modify your apache config file to use new directory structure:

for Apache 2.2:
```shell
mkdir /usr/local/etc/apache22/extra/sites-available;
mkdir /usr/local/etc/apache22/extra/sites-enabled;
echo 'Include etc/apache22/extra/sites-enabled/*.conf' >> /usr/local/etc/apache24/extra/httpd-vhosts.conf;
```
for Apache 2.4:
```shell
mkdir /usr/local/etc/apache24/extra/sites-available;
mkdir /usr/local/etc/apache24/extra/sites-enabled;
echo 'Include etc/apache24/extra/sites-enabled/*.conf' >> /usr/local/etc/apache24/extra/httpd-vhosts.conf;
```

### Every time
```shell
sh vhost.sh
```

## TODO:
- add custom template names;
- add some validation rules;