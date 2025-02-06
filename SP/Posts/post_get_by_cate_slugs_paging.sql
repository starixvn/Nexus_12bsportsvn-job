/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS post_get_by_cate_slugs_paging;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_by_cate_slugs_paging`(
	slug1 VARCHAR(255),
    slug2 VARCHAR(255),
    slug3 VARCHAR(255),
    start INT,
    end INT
	
	/*
		Creator: Hank@20220805
        Revisions:
			- 20220805@Hank: init
			- 202200805@Hank: remove get by tag
    */
)
GetSlug:BEGIN
	DECLARE count  INT;
	DECLARE category INT;
    DECLARE cate_parent INT;
    DECLARE slug VARCHAR(200);
    
    SET slug = get_cate_slug(slug1, slug2, slug3);
    
    IF (slug is null) THEN
		LEAVE GetSlug;
    END IF;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT);
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Cate;
    CREATE TEMPORARY TABLE tmp_Cate (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
    
	SELECT t.term_id INTO category
    FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" WHERE t.slug = slug;
    
    INSERT INTO tmp_Cate (term_id, slug, term_taxonomy_id)
    SELECT t.term_id, t.slug, wtt.term_taxonomy_id
    FROM wp_terms t
    INNER JOIN wp_term_taxonomy as wtt ON wtt.term_id = t.term_id AND wtt.taxonomy = "category" 
    WHERE wtt.term_id = category OR wtt.parent = category;
    
    INSERT INTO tmp_Cate (term_id, slug, term_taxonomy_id)
    SELECT t.term_id, t.slug, wtt.term_taxonomy_id
    FROM wp_terms t
    INNER JOIN wp_term_taxonomy as wtt ON wtt.term_id = t.term_id AND wtt.taxonomy = "category" 
    WHERE wtt.parent IN (SELECT wtt1.term_id FROM wp_term_taxonomy as wtt1 WHERE wtt1.parent = category);
    
    INSERT INTO tmp_PostIds (PostId)
    SELECT p.ID
	FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cate as c ON c.term_taxonomy_id = tr.term_taxonomy_id);
	
    SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent, p.post_excerpt as PostExcerpt
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug
    , pp.guid as FeatureImage, m1.meta_value as Metadata, p.comment_count as CommentCount
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND EXISTS (SELECT tmp.PostId FROM tmp_PostIds tmp WHERE tmp.PostId = p.ID)
	ORDER BY p.post_date DESC
    LIMIT start, end;
	
    
END

//
DELIMITER ;	