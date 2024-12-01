#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -h HOSTNAME -P PORT -d DATABASE -u USERNAME -p PASSWORD -b BACKUP_FILE"
    echo "  -h HOSTNAME     The MySQL server hostname (default: localhost)."
    echo "  -P PORT         The MySQL server port (default: 3306)."
    echo "  -d DATABASE     The name of the database."
    echo "  -u USERNAME     The MySQL username."
    echo "  -p PASSWORD     The MySQL password."
    echo "  -b BACKUP_FILE  The name of the backup file."
    exit 1
}

# Default values
HOSTNAME="localhost"
PORT="3306"

# Parse arguments
while getopts ":h:P:d:u:p:b:" opt; do
  case $opt in
    h) HOSTNAME="$OPTARG" ;;
    P) PORT="$OPTARG" ;;
    d) DB_NAME="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    b) BACKUP_FILE="$OPTARG" ;;
    *) usage ;;
  esac
done

# Validate arguments
if [ -z "$DB_NAME" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$BACKUP_FILE" ]; then
    usage
fi

# Restore the backup
echo "Restoring backup from $BACKUP_FILE to database $DB_NAME"
mysql -h "$HOSTNAME" -P "$PORT" -u "$USERNAME" -p"$PASSWORD" "$DB_NAME" < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Restore completed successfully."
else
    echo "Restore failed."
    exit 1
fi
