# FreeBSD "add virtual host" shell script

Basic script, which:
- promt $hostname, $username and $password;
- add FreeBSD user with given $username and $password;
- create apache and nginx `$username.conf` files in `sites-available` dirs from `_template_yii.conf` templates with `{{username}}` and `{{hostname}}` placeholders;
- create `sites-enabled` symlinks;
- restart

## Usage

1. Adapt paths according to your configuration (I use `/u1/www/hosting/$username` for host files locations);
2. If not exist create `_template_yii.conf` template files in apache and nginx `sites-available` dirs. Use `{{username}}` and `{{hostname}}` placeholders for username and hostname values;
3. ```sh vhost.sh```

## TODO:
- add custom template names;
- add some validation rules;
