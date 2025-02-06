/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_get_report;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_report`(
	IN fromDate DATE,
    IN toDate DATE,
    IN search NVARCHAR(200),
    IN searchType NVARCHAR(200),
    IN dateSort NVARCHAR(100),
    IN start INT,
    IN end INT,
    OUT TotalItems INT
    
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20240815@Hank: select phone, yearOfBirth
			- 20240911@Hank: filter user by search type
    */
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_UserIds;
    CREATE TEMPORARY TABLE tmp_UserIds (ID BIGINT);
    
    IF searchType = 'name' THEN
		INSERT INTO tmp_UserIds (ID)
        SELECT u.ID
		FROM wp_users as u
		LEFT JOIN wp_usermeta as m ON m.user_id = u.ID and m.meta_key = 'email_confirmed'
		WHERE DATE(user_registered) BETWEEN fromDate  AND toDate 
		AND u.display_name LIKE CONCAT('%',search, '%')
		AND m.meta_value = 1;
	ELSEIF  searchType = 'email' THEN
		INSERT INTO tmp_UserIds (ID)
        SELECT u.ID
		FROM wp_users as u
		LEFT JOIN wp_usermeta as m ON m.user_id = u.ID and m.meta_key = 'email_confirmed'
		WHERE DATE(user_registered) BETWEEN fromDate  AND toDate 
		AND u.user_email LIKE CONCAT('%',search, '%')
		AND m.meta_value = 1;
	ELSEIF  searchType = 'sabaId' THEN
		INSERT INTO tmp_UserIds (ID)
        SELECT u.ID
		FROM wp_users as u
		LEFT JOIN wp_usermeta as m ON m.user_id = u.ID and m.meta_key = 'email_confirmed'
		WHERE u.ID LIKE CONCAT('%',search, '%')
		AND m.meta_value = 1;
	ELSEIF searchType = 'birthday' THEN
		INSERT INTO tmp_UserIds (ID)
        SELECT u.ID
		FROM wp_users as u
		LEFT JOIN wp_usermeta as m ON m.user_id = u.ID and m.meta_key = 'email_confirmed'
        LEFT JOIN wp_usermeta as m1 ON m1.user_id = u.ID and m1.meta_key = 'year_of_birth'
		WHERE DATE(user_registered) BETWEEN fromDate  AND toDate 
		AND m1.meta_value LIKE CONCAT('%',search, '%')
		AND m.meta_value = 1;	
	ELSEIF searchType = 'phone' THEN
		INSERT INTO tmp_UserIds (ID)
        SELECT u.ID
		FROM wp_users as u
		LEFT JOIN wp_usermeta as m ON m.user_id = u.ID and m.meta_key = 'email_confirmed'
        LEFT JOIN wp_usermeta as m1 ON m1.user_id = u.ID and m1.meta_key = 'phone'
		WHERE DATE(user_registered) BETWEEN fromDate  AND toDate 
		AND m1.meta_value LIKE CONCAT('%',search, '%')
		AND m.meta_value = 1;	
    END IF;
	
	SELECT count(*) INTO TotalItems FROM tmp_UserIds;
    
    SELECT user.ID,
		user_email as Email,
		display_name as `Name`,
        user_pass as `Password`,
		m2.meta_value as Phone,
        m3.meta_value as YearOfBirth,
        CONVERT(IFNULL(m.meta_value, 0), SIGNED) as EmailConfirmed,
        user_registered as RegisterDate
    FROM wp_users as user
    INNER JOIN tmp_UserIds as tmp ON tmp.ID = user.ID 
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'year_of_birth'
    ORDER BY CASE WHEN dateSort = 'asc' THEN user_registered END
			,user_registered desc
	LIMIT start, end;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_UserIds;

END

//
DELIMITER ;