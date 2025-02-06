/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_create;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create`(
	IN _name NVARCHAR(200),
    IN _email VARCHAR(100),
    IN _password VARCHAR(200),
    IN _phone VARCHAR(20),
    IN _yearOfBirth VARCHAR(50),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100),
    OUT UserId INT
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20240808@Hank: _phone, _yearOfBirth
            - 20240828@Hank: check not confirm email
    */
)
User_Create:BEGIN

    SET UserId = -1;
    
	SELECT u.ID
	INTO UserId
	FROM `wp_users` u
	WHERE u.user_login = _email OR u.user_email = _email;

    
    IF (UserId != 1) THEN
		IF (EXISTS(SELECT 1 FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key='email_confirmed' AND um.meta_value = '1')) THEN
			SET ErrCode = 1,
			ErrMsg = 'Email đã tồn tại';
			LEAVE User_Create;
        END IF;
        
        IF (EXISTS(SELECT 1 FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key='email_confirmed' AND um.meta_value = '0')) THEN
			SET ErrCode = 2,
			ErrMsg = 'Email chưa xác thực';
            
            UPDATE `wp_users`
			SET
			`user_pass` = _password,
			`user_nicename` = _name,
			`display_name` = _name
			WHERE `ID` = UserId;

			LEAVE User_Create;
        END IF;
		
	END IF;
    
	INSERT INTO `wp_users`
	(`user_login`,
	`user_pass`,
	`user_nicename`,
	`user_email`,
	`user_registered`,
	`user_status`,
	`display_name`)
	VALUES
	(_email,
	_password,
	_name,
	_email,
	LOCALTIME(),
	0,
	_name
	);
	
	SET UserId = LAST_INSERT_ID();
	
	INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'nickname',
	_name);
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'first_name',
	_name);
    
	INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'phone',
	_phone);
    
     INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'year_of_birth',
	_yearOfBirth);
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'wp_capabilities',
	'a:0:{}');
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'email_confirmed',
	0);
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'is_subscribe',
	1);
    
END

//
DELIMITER ;	