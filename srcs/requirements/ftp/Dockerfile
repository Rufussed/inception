# Use Debian Bullseye as base image
FROM debian:bullseye

# Install vsftpd and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create FTP user and set up home directory
RUN useradd -m -d /home/ftpuser -s /bin/bash ftpuser

# Create vsftpd secure chroot directory
RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty

# Copy vsftpd config
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
