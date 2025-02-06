/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_verify_token_reset;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_verify_token_reset`(
    IN id INT,
    IN token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
			- 20240814@Hank: refactor code
    */
)
User_Verify_Token_Reset:BEGIN
    IF (!EXISTS(SELECT 1 FROM `wp_users` AS u 
				INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'token_reset'
                WHERE u.ID = id AND m.meta_value = token)) 
	THEN
		SET ErrCode = 1,
			ErrMsg = 'Token không tồn tại';
        LEAVE User_Verify_Token_Reset;
	END IF;
END

//
DELIMITER ;	