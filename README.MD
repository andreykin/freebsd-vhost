# FreeBSD "add virtual host" shell script

Basic script, which:
- promts $hostname, $username and $password;
- add new FreeBSD user with given $username and $password;
- create  apache and nginx `$username.conf` files in `sites-available` dirs from `_template_yii.conf` templates with `{{username}}` and `{{hostname}}` placeholders;
- create symlinks points to this files in `sites-enabled` dirs;
- restart

## Usage

1. If not exist create `_template_yii.conf` template files in apache and nginx `sites-available` dirs. Use `{{username}}` and `{{hostname}}` placeholders for username and hostname values;
2. ```sh vhost.sh```

## TODO:
- add custom template names;
- add some validation rules;
