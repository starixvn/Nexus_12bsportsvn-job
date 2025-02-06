/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_create_token_confirm;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_token_confirm`(
	IN Email VARCHAR(200),
    IN Token VARCHAR(200),
    OUT UserId BIGINT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
			- 20240808@Hank: add output UserId
            - 20240815@Hank: refactor code
            - 20240826@Hank: change Error Code
    */
)
User_Create_Token_Confirm:BEGIN
    SET UserId = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'wp_capabilities'
	WHERE u.user_login = Email AND u.user_email = Email AND m.meta_value = 'a:0:{}';
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User không tồn tại';
        LEAVE User_Create_Token_Confirm;
	END IF;
    
    
    IF (EXISTS(SELECT * FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key='email_confirmed' AND um.meta_value = '1')) 
    THEN
		SET ErrCode = 2,
			ErrMsg = 'Tài khoản này đã đăng ký thành công';
        LEAVE User_Create_Token_Confirm;
	END IF;
    
    
    IF (EXISTS(SELECT 1 FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key = 'token_confirmed')) THEN
		UPDATE `wp_usermeta` as m 
		SET meta_value = Token
		WHERE m.user_id = UserId AND m.meta_key = 'token_confirmed';
	ELSE
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'token_confirmed',
		Token);
	END IF;
END

//
DELIMITER ;	