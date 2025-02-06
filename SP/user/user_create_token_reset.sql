/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_create_token_reset;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_token_reset`(
	IN Email VARCHAR(200),
    IN Token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
			- 20240814@Hank: refactor code
    */
)
User_Create_Token_Reset:BEGIN

	DECLARE UserId INT;
    DECLARE UMetaId INT;
    DECLARE UConfirm INT;
    SET UserId = -1;
    SET UMetaId = -1;
    SET UConfirm = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
	WHERE u.user_login = Email AND u.user_email = Email;
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email không tồn tại';
        LEAVE User_Create_Token_Reset;
	END IF;
    
    
    IF (!EXISTS(SELECT 1 FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key='email_confirmed' AND um.meta_value = '1')) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email không tồn tại';
        LEAVE User_Create_Token_Reset;
	END IF;
    
    
    IF (EXISTS(SELECT 1 FROM wp_usermeta as um WHERE um.user_id = UserId AND um.meta_key = 'token_reset')) THEN
		UPDATE `wp_usermeta` as m
		SET meta_value = Token
		WHERE m.user_id = UserId AND m.meta_key = 'token_reset';
	ELSE
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'token_reset',
		Token);
	END IF;
END

//
DELIMITER ;	