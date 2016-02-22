# FreeBDS vhost add shell script

Basic script, which:
- promts hostname, username and password;
- add new FreeBSD user with given password;
- create new apache and nginx config files for virtual host in "`sites-available`" dirs. Configs are based on template with $username and $hostname placeholders;
- create symnlinks, points to this files in "`sites-enabled`" dirs;
- restart

Usage

```shell
sh vhost.sh
```