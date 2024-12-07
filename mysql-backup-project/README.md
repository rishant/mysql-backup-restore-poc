# Run the Project

## Start the Docker container:

    cmd:/> docker-compose up -d --build

## Run Full Backup:
    Execute the script inside the container:

    cmd:/> docker exec mysql_container /usr/local/bin/full-backup.sh

## Run Incremental Backup:
    Execute the script inside the container:

    cmd:/> docker exec mysql_container /usr/local/bin/incremental-backup.sh

## Restore Backup:
    Stop the application to avoid conflicts, then run the restore script:

    cmd:/> docker exec mysql_container /usr/local/bin/restore.sh


# 5. Automate Backups with Cron
Add a cron job in the container:

## Access the container shell:
    cmd:/> docker exec -it mysql_container bash

## Edit the cron jobs:
    cmd:/> crontab -e

## Add the following entries:

    ### Full backup at 2 AM daily
    0 2 * * * /usr/local/bin/full-backup.sh

    ### Incremental backup every hour
    0 * * * * /usr/local/bin/incremental-backup.sh

## Restart cron service inside the container (if applicable).