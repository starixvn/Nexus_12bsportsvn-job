/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_posts_by_cate_slug;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_cate_slug`(
	_categorySlug VARCHAR(200),
    postType VARCHAR(200),
    _start INT,
    _end INT,
    OUT TotalItems int
	 /*
		Creator: Hank@20210720
        Revisions:
			- 20210720@Hank: init
            - 20221001@Hank: get sub cate from function & filter by post type
            - 20230525@Hank: refactor
    */
)
BEGIN
	DECLARE count  INT;
	DECLARE category INT;
    DECLARE cate_name VARCHAR(200);
    DECLARE cate_parent_name VARCHAR(200);
    DECLARE cate_parent INT;
    DECLARE result JSON;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT);
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Terms;
    CREATE TEMPORARY TABLE tmp_Terms (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
    
    SET result = get_sub_cate(_categorySlug);
    
	INSERT INTO tmp_Terms (term_id, slug, term_taxonomy_id)
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
	WHERE p.post_type = postType AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cate as c ON c.term_taxonomy_id = tr.term_taxonomy_id);
                    
	SELECT count(*) INTO TotalItems FROM tmp_PostIds;
	
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent, p.post_excerpt as PostExcerpt
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug
    , pp.guid as FeatureImage, m1.meta_value as Metadata, p.comment_count as CommentCount
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE EXISTS (SELECT tmp.PostId FROM tmp_PostIds tmp WHERE tmp.PostId = p.ID)
	ORDER BY p.post_date DESC
	limit _start, _end;
	
END
//
DELIMITER ;	