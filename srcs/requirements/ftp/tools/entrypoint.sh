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

# Add FTP user to www-data group and set permissions for FTP write access
usermod -aG www-data $FTP_USER
chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf
