---- Full Backup/Restore -------
mysqldump --user=root --password=root --host=example2.xyz.com --port=3306 user_management > /data/mysql_backup/user_management_db_full_backup.sql

mysql --user=root --password=root --host=example1.xyz.com --port=3308 user_management < /data/mysql_backup/user_management_db_full_backup.sql


----- Delta Backup/Restore ------
chmod +x mysql_delta_backup_script.sh mysql_delta_restore_script.sh

/data/mysql_delta_backup_script.sh -h example2.xyz.com -P 3306 -d user_management -u root -p root -s "2024-11-01 00:00:00" -e "2024-11-28 23:59:59" -b /data/mysql_backup/user_management_db_delta_backup_28Nov.sql

/data/mysql_delta_restore_script.sh -h example1.xyz.com -P 3308 -d user_management -u root -p root -b /data/mysql_backup/user_management_db_delta_backup_28Nov.sql

SELECT count(*)
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'your_database_name'

SELECT TABLE_NAME, CREATE_TIME
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'your_database_name' AND CREATE_TIME BETWEEN 'YYYY-MM-DD HH:MM:SS' AND 'YYYY-MM-DD HH:MM:SS'
ORDER BY CREATE_TIME;

SELECT TABLE_NAME, CREATE_TIME
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'your_database_name' AND CREATE_TIME BETWEEN 'YYYY-MM-DD HH:MM:SS' AND NOW()
ORDER BY CREATE_TIME;

----- Procedure Defination --------------
drop_tables_from schema_procedure.sql

	-- Assume the current date is November 30, 2024.
	CALL DropTablesInRange(12, 6, 'user_management');
