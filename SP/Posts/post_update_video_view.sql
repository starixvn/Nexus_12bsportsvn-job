/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_update_video_view;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_update_video_view`( 
	postId BIGINT(20) UNSIGNED, 
	errCode INT, 
	errMsg NVARCHAR(100)
     /*
		Creator: Hank@20240415
        Revisions:	
			- 20240415@Hank: init
    */
)
BEGIN
	INSERT INTO `wp_postview_details`
    (`post_id`,
    `is_video_post`,
    `view_date`,
    `video_view`)
    VALUES
    (postId,
    1,
    CURRENT_DATE(),
    1)
    ON DUPLICATE KEY UPDATE `video_view` = `video_view` + 1;
    
    IF (EXISTS(
        SELECT * FROM `wp_postmeta` wpm 
        WHERE wpm.post_id = postId 
        AND wpm.meta_key = 'trx_addons_video_views_count' ))
    THEN
        UPDATE wp_postmeta 
		SET meta_value = meta_value + 1
		WHERE post_id = postId AND meta_key = "trx_addons_video_views_count";
    ELSE
        INSERT INTO `wp_postmeta`
		(`post_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(postId,
		'trx_addons_video_views_count',
		1);
    END IF;
	
END
//
DELIMITER ;	