/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_post_detail_by_slug;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_post_detail_by_slug`(
	Slug varchar(200), 
    PostType varchar (30)
    
    /*
		Creator: Hank@20210203
        Revisions:	- 20210203@Hank: init
					- 20231303@Hank: add author
                    - 20230707@Hank: add seo data
    */
)
BEGIN
	DECLARE PostId varchar(100);
	DECLARE tags varchar(600);
    DECLARE tagsSlug varchar(600);
    DECLARE cate_name varchar(600);
    DECLARE cate_id varchar(600);
    DECLARE categoriesSlug varchar(600);
    DECLARE checkViews INT;
    
    SELECT p.ID INTO  PostId FROM wp_posts p where p.post_name = Slug AND p.post_status = 'publish' AND p.post_type = PostType ;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.slug separator ', ')
    INTO tags, tagsSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'post_tag'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE  t_r.object_id = PostId;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.term_id separator ', '), group_concat(t.slug separator ', ')
    INTO cate_name, cate_id, categoriesSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'category'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE t_r.object_id = PostId;
    
	SELECT p.ID, p.post_title as  PostTitle, p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_content as PostContent, 
    p.post_excerpt as PostExcerpt, p.post_name as PostName, pp.guid as FeatureImage, m1.meta_value as Metadata, p.comment_count as CommentCount, 
    tags as Tags, tagsSlug as TagsSlug, cate_name as CatesName, cate_id as Categories, categoriesSlug, p.post_author as AuthorId, u.display_name as Author,
    yi.title as SeoTitle, yi.description as SeoDescription
    FROM wp_posts p
    LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment"
    LEFT JOIN wp_users as u ON u.ID = p.post_author
    LEFT JOIN wp_yoast_indexable yi ON yi.object_id = p.ID AND yi.object_type = "post" 
    WHERE p.ID = PostId AND p.post_status = 'publish';
END

//
DELIMITER ;	