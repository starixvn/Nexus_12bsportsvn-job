/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_by_jsonIds;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_by_jsonIds`(
	ids TEXT,
    limitItem INT
    /*
		Creator: Hank@20230911
        Revisions: - 20230911@Hank: init
    */
)
BEGIN
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug
    , pp.guid as FeatureImage
    , p.comment_count as CommentCount, p.post_excerpt as PostExcerpt
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE FIND_IN_SET(p.id, ids) AND p.post_type = 'post' AND p.post_status = 'publish'
    ORDER BY p.post_date desc
    LIMIT limitItem;
END
//
DELIMITER ;	