/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS get_post_detail_by_postid;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_post_detail_by_postid`(
	/*
		Creator: Brian@20220913
        Revisions:
			- 20220913@Brian: init
    */
	_postId varchar(200)
)
BEGIN
	DECLARE PostId varchar(100);
	DECLARE tags varchar(600);
    DECLARE tagsSlug varchar(600);
    DECLARE cate_name varchar(600);
    DECLARE cate_id varchar(600);
    DECLARE categoriesSlug varchar(600);
    DECLARE checkViews INT;
    
    SELECT p.ID INTO  PostId FROM wp_posts p where p.ID = _postId AND p.post_status = 'publish' ;
    
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
    
	SELECT p.ID, p.post_author AS EditorId, p.post_title AS PostTitle, p.post_date, p.post_date_gmt, p.post_content AS PostContent, p.post_excerpt, p.post_name AS PostName, pp.guid as feature_image, m1.meta_value as metadata, p.comment_count, tags, tagsSlug, cate_name as CatesName, cate_id, categoriesSlug
    FROM wp_posts p
    LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
    WHERE p.ID = PostId AND p.post_status = 'publish';
END

//
DELIMITER ;	