FROM mysql:8.0-debian

# Install cron for scheduling
RUN apt-get update && apt-get install -y cron && apt-get clean

# Set up directory for backups and logs
RUN mkdir -p /var/backups /var/log/mysql && chmod -R 777 /var/backups /var/log/mysql

# Add scripts
COPY scripts/full-backup.sh /usr/local/bin/full-backup.sh
COPY scripts/incremental-backup.sh /usr/local/bin/incremental-backup.sh
COPY scripts/restore.sh /usr/local/bin/restore.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/*.sh

CMD ["mysqld"]
