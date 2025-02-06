/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS posts_sitemap_get_by_date;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `posts_sitemap_get_by_date`(
	date DATETIME
    /*
		Creator: Hank@20230614
        Revisions:
			- 20230614@Hank: init
    */
)
BEGIN
    
	SELECT  p.ID, p.post_title as PostTitle, p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_content as PostContent, p.post_name as Slug
    FROM wp_posts p
    LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
    WHERE p.post_type = 'post'AND p.post_status = 'publish' AND DATE(p.post_date) = DATE(date)
    ORDER BY p.post_date DESC;
END

//
DELIMITER ;	