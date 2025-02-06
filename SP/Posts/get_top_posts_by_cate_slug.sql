/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_top_posts_by_cate_slug;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_top_posts_by_cate_slug`(
	cateSlug varchar(200),
    postId BIGINT,
    start INT,
    end INT
    /*
		Creator: Hank@20210720
        Revisions:
			- 20210720@Hank: init
            - 20220727@Hank: get sub cate posts
            - 20220823@Hank: change hour to get posts
            - 20220830@Hank: order by view
    */
)
BEGIN
	DECLARE category INT;
    DECLARE limitDate DATETIME;
    DECLARE result JSON;
    SELECT DATE_SUB(UTC_TIMESTAMP, INTERVAL 36 HOUR) INTO limitDate;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT);
    
     DROP TEMPORARY TABLE IF EXISTS tmp_Cates;
    CREATE TEMPORARY TABLE tmp_Cates (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
    
    SET result = get_sub_cate(cateSlug);
    
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
	WHERE p.post_type = 'post' AND p.post_status = 'publish' AND p.post_date_gmt >= limitDate  AND p.ID != postId
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cates as c ON c.term_taxonomy_id = tr.term_taxonomy_id);
	
    IF (SELECT COUNT(*) FROM tmp_PostIds) = 0 THEN 
		SELECT DATE_SUB(UTC_TIMESTAMP, INTERVAL 72 HOUR) INTO limitDate;
        INSERT INTO tmp_PostIds (PostId)
		SELECT p.ID
		FROM wp_posts as p
		WHERE p.post_type = 'post' AND p.post_status = 'publish' AND p.post_date_gmt >= limitDate AND p.ID != postId
		AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
						INNER JOIN tmp_Cates as c ON c.term_taxonomy_id = tr.term_taxonomy_id);
    END IF;
    
    IF (SELECT COUNT(*) FROM tmp_PostIds) = 0 THEN 
		SELECT DATE_SUB(UTC_TIMESTAMP, INTERVAL 168 HOUR) INTO limitDate;
        INSERT INTO tmp_PostIds (PostId)
		SELECT p.ID
		FROM wp_posts as p
		WHERE p.post_type = 'post' AND p.post_status = 'publish' AND p.post_date_gmt >= limitDate  AND p.ID != postId
		AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
						INNER JOIN tmp_Cates as c ON c.term_taxonomy_id = tr.term_taxonomy_id);
    END IF;
    
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug, pp.guid as FeatureImage
    , m1.meta_value as Metadata, pm.meta_value as views, p.comment_count as CommentCount
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as pm ON pm.post_id = p.ID AND pm.meta_key = "trx_addons_post_views_count"
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment"
	WHERE p.post_type = "post" AND p.post_status = "publish" AND p.post_date_gmt >= limitDate
	AND p.ID IN (SELECT tmp.PostId FROM tmp_PostIds tmp WHERE tmp.PostId = p.ID)
	ORDER BY ABS(pm.meta_value) DESC
    limit start, end;
END
//
DELIMITER ;	