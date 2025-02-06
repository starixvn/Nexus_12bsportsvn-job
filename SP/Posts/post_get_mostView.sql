/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_mostView;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_mostView`(
    startRow INT,
    rowLimit INT
    /*
		Creator: Hank@20240320
        Revisions:
			- 20240320@Hank: init
    */
)
BEGIN
    DECLARE limitDate DATETIME;
    SELECT DATE_SUB(UTC_TIMESTAMP, INTERVAL 24 HOUR) INTO limitDate;
	
    
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug, pp.guid as FeatureImage
    , pm.meta_value as views, p.comment_count as CommentCount
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as pm ON pm.post_id = p.ID AND pm.meta_key = "trx_addons_post_views_count"
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment"
	WHERE p.post_type = "post" AND p.post_status = "publish" AND p.post_date_gmt >= limitDate
	ORDER BY ABS(pm.meta_value) DESC
    limit startRow, rowLimit;
END
//
DELIMITER ;	