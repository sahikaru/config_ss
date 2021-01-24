#! /bin/bash

yum install epel-release -y
yum update -y
yum install python-setuptools m2crypto supervisor -y
easy_install pip
pip install shadowsocks

# create shadowsocks.conf file
file_name='/etc/shadowsocks.json'
touch $file_name
echo '{' >> $file_name
echo '    "server": "0.0.0.0",' >> $file_name
echo '    "server_port": 8388,' >> $file_name 
echo '    "local_port": 1080,' >>  $file_name
echo '    "passport": "10241024",' >> $file_name
echo '    "timeout": 600,' >> $file_name 
echo '    "method":"aes-256-cfb"' >> $file_name 
echo '}' >> $file_name

# config supervisord.conf
echo '[program:shadowsocks]' >> /etc/supervisord.conf
echo 'command=ssserver -c /etc/shadowsocks.json' >> /etc/supervisord.conf
echo 'autostart=true' >> /etc/supervisord.conf
echo 'autorestart=true' >> /etc/supervisord.conf
echo 'user=root' >> /etc/supervisord.conf
echo 'log_stderr=true' >> /etc/supervisord.conf
echo 'logfile=/var/log/shadowsocks.log' >> /etc/supervisord.conf

# config /etc/rc.local
echo 'service supervisord start' >> /etc/rc.local

# run server
ssserver -c /etc/shadowsocks.json

