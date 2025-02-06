/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS rss_get_recent;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `rss_get_recent`(
		/*
			Creator: Hank@20230523
			Revisions: - 20230523@Hank: init
					   - 20230817@Hank: select postId
		*/
	)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
	CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT);
	
	INSERT INTO tmp_PostIds (PostId)
	SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "post_format"
					INNER JOIN wp_terms as t ON t.term_id = tt.term_id AND t.slug = "post-format-video";
					
	SELECT p.ID, p.post_name As Slug
		  ,p.post_title AS PostTitle
		  ,p.post_excerpt AS PostExcerpt
		  ,p.post_content AS PostContent
		  ,p.post_date_gmt AS PostDateGMT, p.post_date AS PostDate
		  ,pp.guid AS FeatureImage
		  ,u.display_name AS Author
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment"
	LEFT JOIN wp_users as u ON u.ID = p.post_author
	WHERE p.post_type = 'post' AND p.post_status = 'publish' 
	AND p.ID NOT IN (SELECT tmp.PostId FROM tmp_PostIds as tmp )
	ORDER BY p.post_date DESC
	limit 50;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
END


//
DELIMITER ;	