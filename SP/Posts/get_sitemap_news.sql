/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_sitemap_news;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_sitemap_news`(
	 /*
		Creator: Hank@20210203
        Revisions:	- 20210203@Hank: init
					- 20230811@Hank: change ModifiedDate
                    - 20230811@Hank: select postId
                    - 20230926@Hank: limit 300 post
    */
)
BEGIN
    SELECT p.ID, p.post_name As Slug
          ,p.post_title AS Title
          ,p.post_date as ModifiedDate
          ,GROUP_CONCAT(t.name separator ', ') AS Tags
	FROM wp_posts p 
    INNER JOIN wp_term_relationships as t_r ON t_r.object_id = p.ID
	INNER JOIN wp_term_taxonomy as t_t ON t_r.term_taxonomy_id = t_t.term_taxonomy_id AND taxonomy = 'post_tag'
	INNER JOIN wp_terms as t ON t_t.term_id = t.term_id
	WHERE p.post_type ="post" and post_name <> ''
		and p.post_status = 'publish'
	GROUP BY p.ID, p.post_name, p.post_title, p.post_date
    ORDER BY p.post_date DESC
    LIMIT 300;
END
//
DELIMITER ;	