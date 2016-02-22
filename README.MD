# FreeBSD "add virtual host" shell script

Basic script, which:
- promt $hostname, $username and $password;
- add FreeBSD user with given $username and $password;
- create apache and nginx `$username.conf` files in `sites-available` dirs from `_template_yii.conf` templates with `{{username}}` and `{{hostname}}` placeholders;
- create `sites-enabled` symlinks;
- restart

## Usage 

### First time
1. Edit `vhosts.sh` to adapt paths according to your configuration (I use `/u1/www` for host files locations);
2. If you use `apache 2.4` instead of `apache 2.2` version, change `apache22` to `apache24` lines in `vhosts.sh`;
3. Create `_template_yii.conf` template files in apache and nginx `sites-available` dirs. Use `{{username}}` and `{{hostname}}` placeholders for username and hostname values;
3. Modify your apache config file to use new directory structure

For Apache 2.2:
```shell
mkdir /usr/local/etc/apache22/extra/sites-available;
mkdir /usr/local/etc/apache22/extra/sites-enabled;
echo 'Include etc/apache22/extra/sites-enabled/*.conf' >> /usr/local/etc/apache24/extra/httpd-vhosts.conf;
```
For Apache 2.4:
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
