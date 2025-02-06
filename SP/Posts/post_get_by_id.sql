/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_by_id;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_by_id`(
	postId BIGINT
    
    /*
		Creator: Hank@20230818
        Revisions:	
			- 20230818@Hank: init
            - 20240410@Hank: select custom schema.org
            - 20240410@Hank: select videoview
             - 20240627@Hank: select primary category
    */
)
GetPostDetailByIdSlug:BEGIN
	DECLARE tags VARCHAR(600);
    DECLARE tagsSlug VARCHAR(600);
    DECLARE cate_name VARCHAR(250);
    DECLARE cate_id VARCHAR(250);
    DECLARE categoriesSlug VARCHAR(250);
    
    DROP TEMPORARY TABLE IF EXISTS tmp_postmeta;
    CREATE TEMPORARY TABLE tmp_postmeta (post_id BIGINT, meta_key VARCHAR(255), meta_value TEXT,pImage varchar(255));

	IF NOT EXISTS (SELECT 1 FROM wp_posts p WHERE p.ID = postId AND p.post_status = 'publish')
	THEN
		LEAVE GetPostDetailByIdSlug;
	END IF;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.slug separator ', ')
    INTO tags, tagsSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'post_tag'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE  t_r.object_id = postId;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.term_id separator ', '), group_concat(t.slug separator ', ')
    INTO cate_name, cate_id, categoriesSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'category'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE t_r.object_id = postId;
    
    INSERT INTO tmp_postmeta (post_id, meta_key, meta_value,pImage)
    SELECT pm.post_id, pm.meta_key, pm.meta_value, pp.guid
    FROM wp_postmeta pm
		left JOIN wp_posts as pp ON pp.ID = pm.meta_value AND pm.meta_key = "_thumbnail_id" AND pp.post_type="attachment"
    WHERE pm.post_id = postId;
    
	SELECT distinct
	p.ID, p.post_title as  PostTitle, p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_modified as PostDateModified,
	p.post_content as PostContent ,p.post_excerpt as PostExcerpt, p.post_name as Slug, p.comment_count as CommentCount, 
    tags as Tags, tagsSlug as TagsSlug, cate_name as CatesName, cate_id as Categories, categoriesSlug, p.post_author as AuthorId, u.display_name as Author,
    yi.title as SeoTitle, yi.description as SeoDescription, yi.schema_article_type as SchemaType
    ,max(CASE
		WHEN pm.meta_key = "_thumbnail_id" THEN pm.pImage 
	END ) as FeatureImage,
    max(CASE
		WHEN pm.meta_key = "saswp_custom_schema_field" THEN pm.meta_value 
	END) as CustomSchema,
    
    max(CASE
		WHEN pm.meta_key = "trx_addons_video_views_count" THEN pm.meta_value 
	END) as VideoViews,
    
     max(CASE
		WHEN pm.meta_key = "_yoast_wpseo_primary_category" THEN pm.meta_value 
	END) as PrimaryCategory
    
    FROM wp_posts p
    LEFT JOIN tmp_postmeta as pm ON pm.post_id = p.ID
    LEFT JOIN wp_users as u ON u.ID = p.post_author
    LEFT JOIN wp_yoast_indexable yi ON yi.object_id = p.ID AND yi.object_type = "post" 
    WHERE p.ID = postId AND p.post_status = 'publish'
    GROUP BY 
		p.ID, p.post_title , p.post_date , p.post_date_gmt , p.post_modified ,
		p.post_content ,p.post_excerpt , p.post_name ,  p.comment_count , 
		tags , tagsSlug , cate_name , cate_id , categoriesSlug, p.post_author,
        u.display_name, yi.title, yi.description, yi.schema_article_type ;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_postmeta;
END
//
DELIMITER ;	