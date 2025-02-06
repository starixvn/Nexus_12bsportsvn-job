DROP PROCEDURE IF EXISTS email_create;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_create`(
	IN EmailTitle varchar(200),
    IN EmailContent TEXT,
    IN EmbeddedLink varchar(200),
    IN SendDate varchar(200),
    IN CreatedBy INT,
    IN Status INT,
    IN CreatedDate varchar(200),
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

END


//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_create;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_create`(
	IN EmailId INT,
    IN UserId INT,
    IN TokenId VARCHAR(200),
    IN EmailAddress VARCHAR(200),
    IN EmailTitle VARCHAR(200),
    IN EmailContent TEXT,
    IN Status INT,
    IN SendTime varchar(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	INSERT INTO `wp_email_detail`
	(`EmailId`,
	`UserId`,
	`TokenId`,
	`EmailAddress`,
	`EmailTitle`,
	`EmailContent`,
	`SendTime`,
    `Status`)
	VALUES
	(EmailId,
	UserId,
	TokenId,
	EmailAddress,
	EmailTitle,
	EmailContent,
	SendTime,
    Status);
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_get;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_get`(
	IN UserId INT,
    IN EmailId INT
)
BEGIN
	DECLARE SubscribeToken VARCHAR(200);
    SELECT u.meta_value INTO SubscribeToken 
    FROM wp_usermeta u 
    WHERE u.meta_key = "subcribe_token" and u.user_id = UserId ;
    
	SELECT d.EmailId, d.TokenId, d.EmailAddress, d.EmailTitle, d.EmailContent, d.SendTime, d.IsUserClicked, d.Status, SubscribeToken
    FROM wp_email_detail d
    WHERE d.UserId = UserId AND d.EmailId = EmailId;
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_get_by_emailId;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_get_by_emailId`(
	IN emailId INT,
    IN search nvarchar(200),
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
    WHERE d.EmailId = emailId AND d.EmailAddress like CONCAT('%', search, '%');
    
	SELECT d.EmailId, d.UserId, d.TokenId, d.EmailAddress, d.EmailTitle, d.EmailContent, d.SendTime, d.IsUserClicked, d.Status
    FROM wp_email_detail d
    WHERE d.EmailId = emailId 
		AND d.EmailAddress like CONCAT('%', search, '%')
        AND CASE when isClicked != -1 then d.IsUserClicked = isClicked else 1 = 1 END
         AND CASE when status != -1 then d.Status = status else 1 = 1 END
		
    limit start, end;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_update_status;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_update_status`(
	IN status INT,
    IN _EmailId INT,
    IN _UserId INT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
email_detail_update_status:BEGIN  

	DECLARE email_id INT;
    DECLARE user_id INT;
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
    `Status` = status
	WHERE `EmailId` = _EmailId AND `UserId` = _UserId;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS email_detail_verify_token;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_verify_token`(
	IN TokenId varchar(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
email_detail_verify_token:BEGIN
	DECLARE email_id INT;
    DECLARE user_id INT;
    DECLARE isClicked INT;
    SET email_id = -1;
    SET isClicked = -1;
    
    SELECT detail.IsUserClicked, detail.EmailId, detail.UserId
    INTO isClicked, email_id, user_id
    FROM wp_email_detail as detail
    WHERE detail.TokenId = TokenId ;
    
    IF(email_id = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token does not exist';
        LEAVE email_detail_verify_token;
	END IF;
    IF(isClicked = 0) THEN
		UPDATE `wp_email_detail`
		SET
		`UserClickedTime` = NOW(),
		`IsUserClicked` = 1
		WHERE `EmailId` = email_id and `UserId` = user_id;
        
    END IF;
	
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS email_get_all;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_all`(
        IN search nvarchar(200),
		IN FromDate varchar(200),
        IN toDate varchar(200),
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
    AND Date(e.CreatedDate) >= FromDate
    AND CASE when YEAR(toDate) != 1 then Date(e.CreatedDate) <= toDate else 1 = 1 END;
    
    
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.CreatedDate, e.Status, u.display_name as CreatedName,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id) as TotalSent,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id and d.IsUserClicked = 1) as TotalClicked 
    FROM wp_email e
    LEFT JOIN wp_users u ON u.ID = e.CreatedBy 
    WHERE e.EmailTitle like CONCAT('%', search, '%')
    AND e.Status != 2
    AND Date(e.CreatedDate) >= FromDate
    AND CASE when YEAR(toDate) != 1 then Date(e.CreatedDate) <= toDate else 1 = 1 END
    ORDER BY e.CreatedDate desc
    limit start, end;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS email_get_all_by_user;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_all_by_user`(
		IN userId INT,
        IN start INT,
        IN end INT
)
BEGIN
	SELECT e.ID, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id) as TotalSent,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id and d.IsUserClicked = 1) as OpenNumber 
    FROM wp_email e
    WHERE e.CreatedBy = userId
    ORDER BY e.SendDate desc
    LIMIT start, end;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS email_get_by_id;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_by_id`(
	IN Id int
)
BEGIN
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.Status
    FROM wp_email e
    WHERE e.ID = Id;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS email_get_by_id;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_by_user`(
		IN userId INT,
        IN search nvarchar(200),
        IN start INT,
        IN end INT,
        OUT totalItems INT
)
BEGIN
	
    SELECT count(*)
    INTO totalItems
    FROM wp_email e
    WHERE e.CreatedBy = userId
    AND e.EmailTitle like CONCAT('%', search, '%');
    
    
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id) as TotalSent,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id and d.IsUserClicked = 1) as TotalClicked 
    FROM wp_email e
    WHERE e.CreatedBy = userId 
		AND e.EmailTitle like CONCAT('%', search, '%')
    ORDER BY e.SendDate desc
    limit start, end;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS email_update;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_update`(
	IN EmailId INT,
    IN EmailTitle VARCHAR(200),
    IN EmailContent TEXT,
    IN EmbeddedLink VARCHAR(200),
    IN SendDate varchar(200),
    IN CreatedBy INT,
    IN Status INT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    
)
email_update:BEGIN
	UPDATE `wp_email`
	SET
	`EmailTitle` = EmailTitle,
	`EmailContent` = EmailContent,
	`EmbeddedLink` = EmbeddedLink,
	`SendDate` = SendDate,
	`CreatedBy` = CreatedBy,
	`Status` = Status
	WHERE `ID` = EmailId;

END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS email_update_status;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_update_status`(
	IN EmailId INT,
    IN Status INT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
  
)
email_update_status:BEGIN
	DECLARE checkID INT;
    SET checkID = -1;
    
    SELECT e.Id 
    INTO checkID
    FROM wp_email e
    WHERE e.ID = EmailId;
    
     IF(checkID = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email does not exist';
        LEAVE email_update_status;
	END IF;
    
    IF(checkID != -1) THEN
		UPDATE `wp_email`
		SET
		`Status` = Status
		WHERE `ID` = EmailId;
	END IF;
	
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_get_all;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_all`(
	userRole nvarchar(200)
)
BEGIN
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
        m5.meta_value as IsSubcribe
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    LEFT JOIN wp_usermeta as m5 ON m5.user_id = user.ID and m5.meta_key = 'is_subscribe'
    Where CASE when userRole = 'customer' then um.meta_value ='a:0:{}' else 1 = 1 END 
    ORDER BY display_name;
    
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_unsubscribe;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_unsubscribe`(
	IN userId INT,
    IN token varchar(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
user_unsubscribe:BEGIN
	declare UMetaId INT;
    declare checkExist INT;
    SET checkExist = -1;
    SET UMetaId = -1;
    
    select u.umeta_id INTO checkExist 
    from wp_usermeta u
    where u.user_id = userId AND u.meta_key = 'subcribe_token' AND u.meta_value = token;
    
     IF (checkExist = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token does not exist';
        LEAVE user_unsubscribe;
	END IF;
    
    select u.umeta_id INTO UMetaId 
    from wp_usermeta u 
    where u.meta_key = 'is_subscribe' AND u.user_id = userId; 
    
    IF UMetaId != -1 THEN
		UPDATE `wp_usermeta`
		SET
		`meta_value` = 0
		WHERE  `umeta_id` = UMetaId;
    ELSE
         INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(userId,
		'is_subscribe',
		0);
    END IF;
    
    DELETE FROM `wp_usermeta`
    WHERE meta_key= 'subcribe_token' AND user_id = userId;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_subscribe_create_token;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_subscribe_create_token`(
	UserId INT,
	Token VARCHAR(200),
    OUT CurrentToken VARCHAR(200),
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
    DECLARE SubscribeToken VARCHAR(200);
    SET SubscribeToken = "";
    
    SELECT m.meta_value
    INTO SubscribeToken
    FROM `wp_usermeta` AS m
    WHERE m.user_id = UserId AND m.meta_key = 'subcribe_token';
    
    IF (SubscribeToken = "") THEN
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'subcribe_token',
		Token);
        SET CurrentToken = Token;
	ELSE 
		SET CurrentToken = SubscribeToken;
	END IF;
END
//
DELIMITER ;