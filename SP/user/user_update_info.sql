/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_update_info;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_update_info`(
	IN UserID INT,
    IN _name VARCHAR(200),
    IN _password VARCHAR(200),
    IN _phone VARCHAR(200),
    IN _gender VARCHAR(200),
    IN _photo LONGTEXT,
    IN _yearOfBirth LONGTEXT,
    IN _isSubscribe INT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20240808@Hank: update yearOfBirth field
    */
)
user_update_info:BEGIN

	DECLARE UserExists INT;
    DECLARE checkName VARCHAR(200);
    DECLARE LogData LONGTEXT;
    
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
    
    IF(EXISTS(SELECT * FROM wp_usermeta WHERE user_id = UserID AND meta_key = 'phone'))
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _phone
        WHERE user_id = UserID AND meta_key = 'phone';
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
    
    IF(EXISTS (SELECT *  FROM wp_usermeta WHERE user_id = UserID AND meta_key = 'year_of_birth'))
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _yearOfBirth
        WHERE user_id = UserID AND meta_key = 'year_of_birth';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'year_of_birth',
		_yearOfBirth);
    END IF;
    
    
    IF(EXISTS(SELECT * FROM wp_usermeta WHERE user_id = UserID AND meta_key = 'gender'))
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _gender
        WHERE user_id = UserID AND meta_key = 'gender';
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
    
    
    IF(EXISTS(SELECT * FROM wp_usermeta WHERE user_id = UserID AND meta_key = 'photo'))
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _photo
        WHERE user_id = UserID AND meta_key = 'photo';
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
    
    
    IF(EXISTS(SELECT * FROM wp_usermeta WHERE user_id = UserID AND meta_key = 'is_subscribe'))
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
    
    SET LogData = CONCAT('{"Id":"', IFNULL(UserID, ''), '","Name":"', IFNULL(_name, ''), '","Gender":"', IFNULL(_gender, ''), '","Phone":"', IFNULL(_phone, ''), '","Photo":"', IFNULL(_photo, ''), '","IsSubscribe":"', IFNULL(_isSubscribe, ''),'"}');
    
     INSERT INTO `wp_Log`
	(`ActorId`,
	`ActionId`,
	`Data`,
    `LogDate`
    )
	VALUES
	(UserID,
     3,
     LogData,
     LOCALTIME()
     );
    
END

//
DELIMITER ;	