#!/bin/bash
set -e

# Set FTP user password from env
if [ -z "$FTP_USER" ]; then
  FTP_USER=ftpuser
fi
if [ -z "$FTP_PASS" ]; then
  FTP_PASS=ftpuserpass
fi

echo "$FTP_USER" > /etc/vsftpd.userlist

echo "$FTP_USER:$FTP_PASS" | chpasswd

# Link WordPress volume to FTP user home
rm -rf /home/$FTP_USER
ln -s /var/www/html /home/$FTP_USER
chown -h $FTP_USER:$FTP_USER /home/$FTP_USER

exec /usr/sbin/vsftpd /etc/vsftpd.conf
