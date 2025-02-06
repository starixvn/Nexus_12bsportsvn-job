DROP PROCEDURE IF EXISTS post_update_view;
DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_update_view`( postId bigint(20) unsigned, isVideoPost bit, errCode int, errMsg nvarchar(100))
BEGIN
    INSERT INTO `wp_postview_details`
    (`post_id`,
    `is_video_post`,
    `view_date`,
    `view_count`)
    VALUES
    (postId,
    isVideoPost,
    CURRENT_DATE(),
    1)
    ON DUPLICATE KEY UPDATE `view_count` = `view_count` + 1;

    IF (EXISTS(
        SELECT * FROM `wp_postmeta` wpm 
        WHERE wpm.post_id = postId 
        AND wpm.meta_key = 'trx_addons_post_views_count' ))
    THEN
        UPDATE wp_postmeta 
		SET meta_value = meta_value + 1
		WHERE post_id = postId AND meta_key = "trx_addons_post_views_count";
    ELSE
        INSERT INTO `wp_postmeta`
		(`post_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(postId,
		'trx_addons_post_views_count',
		1);
    END IF;
END
//
DELIMITER ;