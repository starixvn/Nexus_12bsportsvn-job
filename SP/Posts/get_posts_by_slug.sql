/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_posts_by_slug;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_slug`(
	categorySlug VARCHAR(200),
    postType VARCHAR(200),
    start INT,
    end INT
    /*
		Creator: Hank@20210720
        Revisions:
			- 20210720@Hank: init
            - 20220727@Hank: get sub cate posts
    */
)
BEGIN
	DECLARE category INT;
	DECLARE cate_name VARCHAR(200);
    DECLARE result JSON;
    
    
	DROP TEMPORARY TABLE IF EXISTS tmp_Cates;
    CREATE TEMPORARY TABLE tmp_Cates (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
    
    SET result = get_sub_cate(categorySlug);
    
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
    
    
   
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug
    , pp.guid as FeatureImage, m1.meta_value as Metadata
    , p.comment_count as CommentCount, p.post_excerpt as PostExcerpt
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = postType AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cates as c ON c.term_taxonomy_id = tr.term_taxonomy_id)
	ORDER BY p.post_date DESC
	limit start, end;
END
//
DELIMITER ;	