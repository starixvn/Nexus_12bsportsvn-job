DROP PROCEDURE IF EXISTS user_membership_event_create_data;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_membership_event_create_data`(
	userId INT,
    luckyNumber VARCHAR(50),
    joinDate DATETIME,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
user_create_membership_event_data:BEGIN
	DECLARE dataExist INT;
    
    SELECT 1 INTO dataExist
    FROM wp_usermeta 
    WHERE user_id = userId AND meta_key = "membership_event_luckynumber";
    
    IF (dataExist = 1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Bạn đã chọn số may mắn rồi, vui lòng kiếm tra lại';
        LEAVE user_create_membership_event_data;
	END IF;
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'membership_event_luckynumber',
	luckyNumber);
    
     INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'membership_event_joindate',
	joinDate);
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS user_membership_event_get_data;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_membership_event_get_data`(
    toDate DATETIME,
	start INT,
    end INT,
    OUT TotalItems INT
)
BEGIN
	SELECT count(*)
    INTO TotalItems
    FROM wp_users as u
    INNER JOIN wp_usermeta as um2 ON u.ID = um2.user_id AND um2.meta_key = "membership_event_luckynumber"
    INNER JOIN wp_usermeta as um3 ON u.ID = um3.user_id AND um3.meta_key = "membership_event_joindate";
	
	SELECT u.ID as UserId, u.display_name as Name, um1.meta_value as Phone
    , um2.meta_value as LuckyNumber, um3.meta_value as JoinDate, u.user_email as Email
    , (SELECT count(*) FROM wp_usermeta WHERE user_id = u.ID AND meta_key = 'membership_event_luckynumber') as NumberSubmit
    FROM wp_users as u
    LEFT JOIN wp_usermeta as um1 ON u.ID = um1.user_id AND um1.meta_key = "phone"
    INNER JOIN wp_usermeta as um2 ON u.ID = um2.user_id AND um2.meta_key = "membership_event_luckynumber"
    INNER JOIN wp_usermeta as um3 ON u.ID = um3.user_id AND um3.meta_key = "membership_event_joindate"
    WHERE um3.meta_value < toDate
    HAVING NumberSubmit = 1
    ORDER BY JoinDate DESC
    LIMIT start, end;
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS user_membership_event_get_detail;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_membership_event_get_detail`(
	userId INT
)
BEGIN
	SELECT u.ID as UserId, um1.meta_value as LuckyNumber, um2.meta_value as JoinDate
    FROM wp_users as u
    INNER JOIN wp_usermeta as um1 ON u.ID = um1.user_id AND um1.meta_key = "membership_event_luckynumber"
    INNER JOIN wp_usermeta as um2 ON u.ID = um2.user_id AND um2.meta_key = "membership_event_joindate"
    WHERE u.ID = userId;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS user_membership_event_get_result;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_membership_event_get_result`(
	resultNumber INT,
	toDate DATETIME,
    start INT,
    end INT
)
BEGIN
SELECT u.ID as UserId, u.display_name as Name, um1.meta_value as LuckyNumber, um2.meta_value as JoinDate
    , u.user_email as Email
    , IF(resultNumber IS NOT NULL AND um1.meta_value REGEXP '^-?[0-9]+$', ABS(um1.meta_value - resultNumber), null) as MatchingRate
    , (SELECT count(*) FROM wp_usermeta WHERE user_id = u.ID AND meta_key = 'membership_event_luckynumber') as NumberSubmit
    FROM wp_users as u
    INNER JOIN wp_usermeta as um1 ON u.ID = um1.user_id AND um1.meta_key = "membership_event_luckynumber"
    INNER JOIN wp_usermeta as um2 ON u.ID = um2.user_id AND um2.meta_key = "membership_event_joindate"
    WHERE um2.meta_value < toDate
    HAVING NumberSubmit = 1
    ORDER BY ISNULL(MatchingRate), MatchingRate 
            , JoinDate
    LIMIT start, end;
    
END
//
DELIMITER ;	


