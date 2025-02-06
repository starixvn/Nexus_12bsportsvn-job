/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_confirm_email;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_confirm_email`(
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
User_Confirm_Email:BEGIN
    IF (!EXISTS(SELECT 1 FROM `wp_users` AS u
				INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'token_confirmed'
                INNER JOIN `wp_usermeta` AS mc ON u.ID = mc.user_id AND mc.meta_key = 'email_confirmed'
                WHERE u.ID = id AND m.meta_value = token AND mc.meta_value = 0)) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token đã tồn tại';
        LEAVE User_Confirm_Email;
	END IF;
    
    UPDATE `wp_usermeta`
    SET meta_value = 1
    WHERE meta_key= 'email_confirmed' AND user_id = id;
    
    DELETE FROM `wp_usermeta`
    WHERE meta_key= 'token_confirmed' AND user_id = id;
END

//
DELIMITER ;	