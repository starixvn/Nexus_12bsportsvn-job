/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS user_get_by_id;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_by_id`(
	IN UserId INT
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
    */
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
        m5.meta_value as IsSubscribe,
        m6.meta_value as YearOfBirth
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    LEFT JOIN wp_usermeta as m5 ON m5.user_id = user.ID and m5.meta_key = 'is_subscribe'
    LEFT JOIN wp_usermeta as m6 ON m6.user_id = user.ID and m6.meta_key = 'year_of_birth'
    WHERE user.ID = UserId;
END

//
DELIMITER ;	