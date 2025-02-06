DROP PROCEDURE IF EXISTS email_detail_remove;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_remove`(
	IN EmailId INT,
    IN UserId INT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100) 
)
BEGIN
	DELETE detail FROM `wp_email_detail` detail
	WHERE detail.EmailId = EmailId AND detail.UserId = UserId AND detail.Status = 2;

END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_update;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_update`(
	IN EmailId INT,
    IN UserId INT,
    IN EmailTitle VARCHAR(200),
    IN EmailContent TEXT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	UPDATE `wp_email_detail` as detail
	SET
	`EmailTitle` = EmailTitle,
	`EmailContent` = EmailContent
	WHERE detail.EmailId = EmailId AND detail.UserId = UserId;

END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_get_for_send;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_for_send`(emailId INT)
BEGIN
	SELECT user.ID as UserId,
		user_email as Email,
		display_name as `Name`,
        e.TokenId as EmailToken,
        e.EmailContent,
        e.EmailTitle,
        (SELECT um3.meta_value 
        FROM wp_usermeta um3
        WHERE um3.user_id = user.ID AND um3.meta_key = "subcribe_token" LIMIT 1) as SubscribeToken
    FROM wp_users as user
    INNER JOIN wp_email_detail as e ON e.UserId = user.ID AND e.EmailId = emailId
    WHERE e.Status = 2
    ORDER BY display_name;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_get_for_send_email;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_for_send_email`()
BEGIN
		SELECT DISTINCT user.ID,
		user_email as Email,
		display_name as `Name`
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'is_subscribe'
    Where um.meta_value ='a:0:{}' AND m1.meta_value = 1 AND ( m2.meta_value is null OR m2.meta_value = 1) 
    ORDER BY display_name;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS email_create_xtest;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_create_xtest`(
	IN EmailTitle VARCHAR(200),
    IN EmailContent TEXT,
    IN EmbeddedLink VARCHAR(200),
    IN SendDate VARCHAR(200),
    IN CreatedBy INT,
    IN Status INT,
    IN CreatedDate varchar(200),
    IN Users LONGTEXT,
    OUT Id INT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	INSERT INTO `wp_email`
	(`EmailTitle`,
	`EmailContent`,
	`EmbeddedLink`,
	`SendDate`,
	`CreatedBy`,
    `Status`,
	`CreatedDate`)
	VALUES
	(EmailTitle,
	EmailContent,
	EmbeddedLink,
	SendDate,
	CreatedBy,
    Status,
	CreatedDate);
    
    SET Id = LAST_INSERT_ID();
    
    DROP TEMPORARY TABLE IF EXISTS tmpUserIds;
    CREATE TEMPORARY TABLE tmpUserIds(ID INT);
    INSERT INTO tmpUserIds(ID)
    SELECT DISTINCT u.ID
    FROM wp_users as u
    WHERE (FIND_IN_SET(u.ID, Users));

    INSERT INTO `wp_usermeta`(`user_id` ,`meta_key`, `meta_value`)
	SELECT u.ID, 'subcribe_token',  UUID_SHORT()
    FROM wp_users as u
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = u.ID and m3.meta_key = 'subcribe_token'
    WHERE u.ID IN (select tmp.ID FROM tmpUserIds as tmp) AND m3.meta_value IS NULL;
    
    INSERT INTO `wp_email_detail`(`EmailId`, `UserId`, `TokenId`, `EmailAddress`, `EmailTitle`, `EmailContent`, `Status`)
    SELECT Id, u.ID, @token := UUID_SHORT() as Token, u.user_email, EmailTitle
			, EmailContent, 2
    FROM wp_users as u
    WHERE u.ID IN (select tmp.ID FROM tmpUserIds as tmp);

END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_filter_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_filter_xtest`(
	IN emailId INT,
    IN search NVARCHAR(200),
    IN isClicked INT,
    IN status INT,
    IN start INT,
    IN end INT,
    OUT totalItems INT
)
BEGIN
	SELECT count(*)
    INTO totalItems
    FROM wp_email_detail d
    WHERE d.EmailId = emailId AND d.EmailAddress LIKE CONCAT('%', search, '%')
    AND d.EmailAddress LIKE CONCAT('%', search, '%')
        AND (isClicked = -1 OR (isClicked != -1 AND d.IsUserClicked = isClicked))
		AND (status = -1 OR (status != -1 AND d.Status = status));
    
	SELECT d.EmailId, d.UserId, d.TokenId, d.EmailAddress, d.EmailTitle, 
    d.EmailContent, d.SendTime, d.IsUserClicked, d.Status,  u.display_name as UserName,
    (SELECT um.meta_value 
        FROM wp_usermeta um
        WHERE um.user_id = u.ID AND um.meta_key = "subcribe_token" LIMIT 1) as SubscribeToken
    FROM wp_email_detail d
    INNER JOIN wp_users as u ON u.ID = d.UserId
    WHERE d.EmailId = emailId 
		AND d.EmailAddress LIKE CONCAT('%', search, '%')
        AND (isClicked = -1 OR (isClicked != -1 AND d.IsUserClicked = isClicked))
		AND (status = -1 OR (status != -1 AND d.Status = status))
    LIMIT start, end;
END
//
DELIMITER ;	



DROP PROCEDURE IF EXISTS email_detail_get_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_get_xtest`(
	IN UserId INT,
    IN EmailId INT
)
BEGIN
	DECLARE SubscribeToken VARCHAR(200);
    SELECT u.meta_value INTO SubscribeToken 
    FROM wp_usermeta u 
    WHERE u.meta_key = "subcribe_token" and u.user_id = UserId LIMIT 1;
    
	SELECT d.EmailId, d.UserId, d.TokenId, d.EmailAddress, d.EmailTitle, d.EmailContent, d.SendTime, d.IsUserClicked, d.Status, SubscribeToken
    FROM wp_email_detail d
    WHERE d.UserId = UserId AND d.EmailId = EmailId;
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_update_status_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_update_status_xtest`(
	IN status INT,
    IN _EmailId INT,
    IN _UserId INT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
email_detail_update_status:BEGIN  

	DECLARE email_id INT;
    DECLARE user_id INT;
    DECLARE numberNewEmail INT;
    SET email_id = -1;
    SET user_id = -1;
	
	SELECT d.EmailId, d.UserId
    INTO email_id, user_id
    FROM wp_email_detail d
    WHERE d.EmailId = _EmailId and d.UserId = _UserId;
    
    IF(email_id = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email detail is not exist';
        LEAVE email_detail_update_status;
	END IF;
    
	UPDATE `wp_email_detail`
	SET
    `Status` = status,
    `SendTime` = UTC_TIMESTAMP()
	WHERE `EmailId` = _EmailId AND `UserId` = _UserId;
    
    SELECT count(*) INTO numberNewEmail
    FROM wp_email_detail as detail
    WHERE detail.EmailId = _EmailId AND detail.Status = 2;
    
    IF(numberNewEmail = 0) THEN
    UPDATE `wp_email`
	SET
    `Status` = 0
	WHERE `ID` = _EmailId;
    END IF;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_get_all_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_all_xtest`(
        IN search NVARCHAR (200),
		IN fromDate VARCHAR(200),
        IN toDate VARCHAR(200),
        IN status INT,
        IN createdBy INT,
        IN start INT,
        IN end INT,
        OUT totalItems INT
)
BEGIN
	
    SELECT count(*)
    INTO totalItems
    FROM wp_email e
    WHERE e.EmailTitle like CONCAT('%', search, '%')
    AND e.Status != 2
    AND Date(e.CreatedDate) >= fromDate
	AND (YEAR(toDate) = 1 OR (YEAR(toDate) != 1 AND Date(e.CreatedDate) <= toDate))
    AND (status = -1 OR (status != -1 AND e.Status = status))
    AND (CreatedBy = -1 OR (CreatedBy != -1 AND e.CreatedBy = createdBy));
    
    
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.CreatedDate, e.Status, u.display_name as CreatedName,
    (SELECT count(*) FROM wp_email_detail as d WHERE d.EmailId = e.Id AND d.Status != 2) as TotalSent,
    (SELECT count(*) FROM wp_email_detail as d WHERE d.EmailId = e.Id) as TotalCreate,
    (SELECT count(*) FROM wp_email_detail as d WHERE d.EmailId = e.Id AND d.IsUserClicked = 1) as TotalClicked
    FROM wp_email e
    LEFT JOIN wp_users u ON u.ID = e.CreatedBy 
    WHERE e.EmailTitle LIKE CONCAT('%', search, '%')
    AND e.Status != 2
    AND Date(e.CreatedDate) >= fromDate
    AND (YEAR(toDate) = 1 OR (YEAR(toDate) != 1 AND Date(e.CreatedDate) <= toDate))
    AND (status = -1 OR (status != -1 AND e.Status = status))
    AND (CreatedBy = -1 OR (CreatedBy != -1 AND e.CreatedBy = createdBy))
    ORDER BY e.CreatedDate desc
    limit start, end;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_get_by_id_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_by_id_xtest`(
	IN Id int
)
BEGIN
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.Status, u.display_name as CreatedName, e.CreatedDate
    FROM wp_email e
    LEFT JOIN wp_users u ON u.ID = e.CreatedBy 
    WHERE e.ID = Id;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_update_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_update_xtest`(
	IN _EmailId INT,
    IN EmailTitle VARCHAR(200),
    IN EmailContent TEXT,
    IN EmbeddedLink VARCHAR(200),
    IN SendDate VARCHAR(200),
    IN CreatedBy INT,
    IN Status INT,
    IN Users LONGTEXT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    
)
BEGIN
	
	UPDATE `wp_email`
	SET
	`EmailTitle` = EmailTitle,
	`EmailContent` = EmailContent,
	`EmbeddedLink` = EmbeddedLink,
	`CreatedBy` = CreatedBy,
	`Status` = Status
	WHERE `ID` = _EmailId;
    
    DROP TEMPORARY TABLE IF EXISTS tmpUserIds;
    CREATE TEMPORARY TABLE tmpUserIds(ID INT);
    INSERT INTO tmpUserIds(ID)
    SELECT DISTINCT u.ID
    FROM wp_users as u
    WHERE (FIND_IN_SET(u.ID, Users));
    
    INSERT INTO `wp_usermeta`(`user_id` ,`meta_key`, `meta_value`)
	SELECT u.ID, 'subcribe_token',  UUID_SHORT()
    FROM wp_users as u
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = u.ID and m3.meta_key = 'subcribe_token'
    WHERE u.ID IN (SELECT tmp.ID FROM tmpUserIds as tmp) AND m3.meta_value IS NULL;
    
    DELETE detail FROM `wp_email_detail` detail
	WHERE detail.EmailId = _EmailId AND (detail.UserId NOT IN (SELECT tmp.ID FROM tmpUserIds as tmp)) AND detail.Status = 2;
    
    
    UPDATE wp_email_detail as detail
    INNER JOIN wp_users as u 
	SET
    detail.EmailTitle = EmailTitle,
    detail.EmailContent = EmailContent
	WHERE EmailId = _EmailId AND u.ID NOT IN (SELECT tmp.ID FROM tmpUserIds as tmp) AND detail.Status = 2;
    
    
    INSERT INTO `wp_email_detail`(`EmailId`, `UserId`, `TokenId`, `EmailAddress`, `EmailTitle`, `EmailContent`, `Status`)
    SELECT _EmailId, u.ID, @token := UUID_SHORT() as Token, u.user_email, EmailTitle
			,EmailContent, 2
    FROM tmpUserIds as tmp
    INNER JOIN wp_users as u ON tmp.ID = u.ID
    WHERE tmp.ID NOT IN (SELECT UserId FROM wp_email_detail WHERE EmailId = _EmailId);
    

END
//
DELIMITER ;	



