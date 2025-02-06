/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS rss_get_category;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `rss_get_category`(
		slug VARCHAR(255)
		/*
			Creator: Hank@20230523
			Revisions: - 20230523@Hank: init
						- 20230817@Hank: select PostId
		*/
	)
BEGIN
	DECLARE category INT;
	DECLARE cate_parent INT;
	DECLARE result JSON;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
	CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT PRIMARY KEY);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Cates;
	CREATE TEMPORARY TABLE tmp_Cates (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
	
	SET result = get_sub_cate(slug);
	
	INSERT INTO tmp_Cates (term_id, slug, term_taxonomy_id)
	SELECT termid, slug, term_taxonomy_id
	FROM 
		JSON_TABLE
		(
			result,
			"$[*]"
			COLUMNS
			(
				termid BIGINT PATH "$.term_id"
				,slug VARCHAR(255) PATH "$.slug"
				,term_taxonomy_id BIGINT PATH "$.term_taxonomy_id"
			)
		) AS t; 
	
	
	INSERT INTO tmp_PostIds (PostId)
	SELECT p.ID
	FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cates as c ON c.term_taxonomy_id = tr.term_taxonomy_id)
	ORDER BY p.post_date_gmt DESC
	LIMIT 50;
	
		
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
	WHERE EXISTS (SELECT tmp.PostId FROM tmp_PostIds tmp WHERE tmp.PostId = p.ID)
	ORDER BY p.post_date_gmt DESC;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
	DROP TEMPORARY TABLE IF EXISTS tmp_Cates;
END


//
DELIMITER ;	