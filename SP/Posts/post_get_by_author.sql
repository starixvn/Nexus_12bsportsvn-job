/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_by_author;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_by_author`(
	authorId BIGINT,
    start INT,
    end INT,
    OUT TotalItems int  
	/*
		Creator: Hank@20230203
        Revisions: - 20230203@Hank: init
    */
)
BEGIN
	
    DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT);
    
    INSERT INTO tmp_PostIds (PostId)
    SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "post_format"
                    INNER JOIN wp_terms as t ON t.term_id = tt.term_id AND t.slug = "post-format-video";	
    
    SELECT count(*)
    INTO TotalItems
	FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish' AND p.post_author = authorId
    AND p.ID NOT IN (SELECT tmp.PostId FROM tmp_PostIds as tmp );
			
    SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent, p.post_excerpt as PostExcerpt
    , p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_name as Slug
    , pp.guid as FeatureImage, m1.meta_value as Metadata, p.comment_count as CommentCount
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish' AND p.post_author = authorId 
    AND p.ID NOT IN (SELECT tmp.PostId FROM tmp_PostIds as tmp )
	ORDER BY p.post_date DESC
    LIMIT start, end;
    
END
//
DELIMITER ;	