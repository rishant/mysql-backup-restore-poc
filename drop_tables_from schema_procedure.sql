CREATE DEFINER=`user1`@`%` PROCEDURE `DropTablesInRange`(
    IN start_interval INT,
    IN end_interval INT,
    IN schema_name VARCHAR(255)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(255);
    DECLARE tbl_schema VARCHAR(255);

    -- Validate input range
    IF start_interval <= end_interval THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid range: start_interval must be greater than end_interval';
    END IF;

    DECLARE cur CURSOR FOR
        SELECT TABLE_SCHEMA, TABLE_NAME
        FROM information_schema.tables
        WHERE CREATE_TIME >= DATE_SUB(CURDATE(), INTERVAL start_interval MONTH)
          AND CREATE_TIME < DATE_SUB(CURDATE(), INTERVAL end_interval MONTH)
          AND TABLE_SCHEMA = schema_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tbl_schema, tbl_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Prepare and execute the dynamic DROP TABLE command
        SET @sql = CONCAT('DROP TABLE `', tbl_schema, '`.`', tbl_name, '`');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END;
