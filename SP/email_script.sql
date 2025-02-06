DROP PROCEDURE IF EXISTS email_get_by_id;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_by_id`(
	IN Id int
)
BEGIN
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.Status, u.display_name as CreatedName
    FROM wp_email e
    LEFT JOIN wp_users u ON u.ID = e.CreatedBy 
    WHERE e.ID = Id;
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_detail_filter;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_detail_filter`(
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
    
	SELECT d.EmailId, d.UserId, d.TokenId, d.EmailAddress, d.EmailTitle, d.EmailContent, d.SendTime, d.IsUserClicked, d.Status, um.meta_value as SubscribeToken
    FROM wp_email_detail d
    LEFT JOIN wp_usermeta um ON um.user_id = d.UserId AND um.meta_key="subcribe_token"
    WHERE d.EmailId = emailId 
		AND d.EmailAddress like CONCAT('%', search, '%')
        AND CASE when isClicked != -1 then d.IsUserClicked = isClicked else 1 = 1 END
         AND CASE when status != -1 then d.Status = status else 1 = 1 END
		
    limit start, end;
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS email_get_all;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `email_get_all`(
        IN search nvarchar(200),
		IN fromDate varchar(200),
        IN toDate varchar(200),
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
    AND CASE when YEAR(toDate) != 1 then Date(e.CreatedDate) <= toDate else 1 = 1 END
    AND CASE when status != -1 then e.Status = status else 1 = 1 END
    AND CASE when CreatedBy != -1 then e.CreatedBy = createdBy else 1 = 1 END;
    
    
	SELECT e.ID, e.EmailTitle, e.EmailContent, e.EmbeddedLink, e.CreatedBy, e.SendDate, e.CreatedDate, e.Status, u.display_name as CreatedName,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id) as TotalSent,
    (SELECT count(*) from wp_email_detail as d where d.EmailId = e.Id and d.IsUserClicked = 1) as TotalClicked 
    FROM wp_email e
    LEFT JOIN wp_users u ON u.ID = e.CreatedBy 
    WHERE e.EmailTitle like CONCAT('%', search, '%')
    AND e.Status != 2
    AND Date(e.CreatedDate) >= fromDate
    AND CASE when YEAR(toDate) != 1 then Date(e.CreatedDate) <= toDate else 1 = 1 END
    AND CASE when status != -1 then e.Status = status else 1 = 1 END
    AND CASE when CreatedBy != -1 then e.CreatedBy = createdBy else 1 = 1 END
    ORDER BY e.CreatedDate desc
    limit start, end;
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
        m5.meta_value as IsSubscribe
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    LEFT JOIN wp_usermeta as m5 ON m5.user_id = user.ID and m5.meta_key = 'is_subscribe'
    Where CASE when userRole = 'customer' then um.meta_value ='a:0:{}' else 1 = 1 END 
		AND m.meta_value = 1
    ORDER BY display_name;
    
END

//
DELIMITER ;	


DROP PROCEDURE IF EXISTS user_get_login;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_login`(
	email VARCHAR(100)
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
        m5.meta_value as IsSubscribe
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    LEFT JOIN wp_usermeta as m5 ON m5.user_id = user.ID and m5.meta_key = 'is_subscribe'
    WHERE user.user_login = email 
		AND user.user_email = email
        AND m.meta_value =  1;
     
END
//
DELIMITER ;	

DROP PROCEDURE IF EXISTS social_user_get_login;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_user_get_login`(
	identifier VARCHAR(200),
    loginType VARCHAR(200)
)
BEGIN
	SELECT user.ID,
			user_email as Email,
			display_name as `Name`,
			user_pass as `Password`,
            m.meta_value as Photo,
			1 as EmailConfirmed,
            su.`type` as LoginType,
            um.meta_value as Metadata,
            m1.meta_value as IsSubscribe
		FROM wp_users as user
        INNER JOIN wp_social_users as su ON su.ID = user.ID AND su.`type` = loginType
		LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'photo'
        LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'is_subscribe'
        LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
		WHERE su.identifier = identifier;
END
//
DELIMITER ;	

DROP PROCEDURE IF EXISTS user_get_by_id;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_by_id`(
	IN UserId INT
)
BEGIN

	DECLARE LoginType nvarchar(200);
    
    SELECT group_concat(s.type separator ',') INTO LoginType FROM wp_social_users s where ID = UserId;
    
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
        LoginType,
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
    WHERE user.ID = UserId;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS user_update_info;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_update_info`(
	IN UserID INT,
    IN _name varchar(200),
    IN _password varchar(200),
    IN _phone varchar(200),
    IN _gender varchar(200),
    IN _photo LONGTEXT,
    IN _isSubscribe INT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
user_update_info:BEGIN

	DECLARE UserExists INT;
    DECLARE checkPhoneExist INT;
    DECLARE checkGenderExist INT;
    DECLARE checkPhotoExist INT;
    DECLARE checkIsSubscribe INT;
    DECLARE checkName varchar(200);
    
	SELECT 1, display_name 
	INTO UserExists, checkName
	FROM `wp_users`
	WHERE ID = UserID;
    
    IF (UserExists != 1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User does not exists';
        LEAVE user_update_info;
	END IF;
    
    
    
    UPDATE `wp_users`
	SET
	`user_pass` = _password,
	`user_nicename` = _name,
	`display_name` = _name
	WHERE `ID` = UserID;
    
    IF(checkName != _name)
    THEN
		UPDATE `wp_comments`
		SET
		`comment_author` = _name
		WHERE `user_id` = UserID;
        
    END IF;
    
    SELECT count(*) INTO checkPhoneExist FROM wp_usermeta where user_id = UserID AND meta_key = 'phone';
    if(checkPhoneExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _phone
        WHERE user_id = UserID ANd meta_key = 'phone';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'phone',
		_phone);
    END IF;
    
    SELECT count(*) INTO checkGenderExist FROM wp_usermeta where user_id = UserID AND meta_key = 'gender';
    if(checkGenderExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _gender
        WHERE user_id = UserID ANd meta_key = 'gender';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'gender',
		_gender);
    END IF;
    
    SELECT count(*) INTO checkPhotoExist FROM wp_usermeta where user_id = UserID AND meta_key = 'photo';
    if(checkPhotoExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _photo
        WHERE user_id = UserID ANd meta_key = 'photo';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'photo',
		_photo);
    END IF;
    
    SELECT count(*) INTO checkIsSubscribe FROM wp_usermeta where user_id = UserID AND meta_key = 'is_subscribe';
    if(checkIsSubscribe > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _isSubscribe
        WHERE user_id = UserID AND meta_key = 'is_subscribe';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'is_subscribe',
		_isSubscribe);
    END IF;
    
END
//
DELIMITER ;	




