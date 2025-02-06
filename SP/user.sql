DROP PROCEDURE IF EXISTS user_get_report;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_report`(
	IN fromDate DATE,
    IN toDate DATE,
    IN search nvarchar(200),
    IN dateSort nvarchar(100),
    IN start INT,
    IN end INT,
    OUT TotalItems INT
)
BEGIN
	SELECT count(*) INTO TotalItems
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    Where DATE(user_registered) BETWEEN fromDate  AND toDate 
    AND (display_name LIKE CONCAT('%',search, '%') OR user_email LIKE CONCAT('%',search, '%'))
	AND um.meta_value ='a:0:{}'
	AND m.meta_value = 1;
    
    
    SELECT user.ID,
		user_email as Email,
		display_name as `Name`,
        user_pass as `Password`,
		m2.meta_value as Phone,
        m3.meta_Value as Gender,
        m4.meta_value as Photo,
        CONVERT(IFNULL(m.meta_value, 0), SIGNED) as EmailConfirmed,
        user_registered as RegisterDate,
        m1.meta_value as SavedPosts,
        um.meta_value as Metadata,
        m5.meta_value as IsSubscribe
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    LEFT JOIN wp_usermeta as m5 ON m5.user_id = user.ID and m5.meta_key = 'is_subscribe'
    Where DATE(user_registered) BETWEEN fromDate  AND toDate 
    AND (display_name LIKE CONCAT('%',search, '%') OR user_email LIKE CONCAT('%',search, '%'))
	AND um.meta_value ='a:0:{}'
	AND m.meta_value = 1
    ORDER BY CASE WHEN dateSort = 'desc' THEN user_registered END desc
			,CASE WHEN dateSort = 'asc' THEN user_registered END
			,user_email
	LIMIT start, end;

END
//
DELIMITER ;	