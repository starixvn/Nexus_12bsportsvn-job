DROP PROCEDURE IF EXISTS search_posts;

DELIMITER //

CREATE DEFINER=`root`@`%` PROCEDURE `search_posts`(
	_keyword TEXT,
    _start INT,
    _end INT,
    OUT TotalItems INT
)
search_posts:BEGIN
    DECLARE keyLength INT;
    DECLARE s TEXT;
    
	SELECT char_length(_keyword) INTO keyLength;

    IF(keyLength <= 2) THEN
		SELECT p.ID, p.post_title as PostTitle, p.post_date as PostDate, p.post_date_gmt as PostDateGMT, 
        p.post_content as PostContent, p.post_name as Slug, pp.guid as FeatureImage, p.post_excerpt as PostExcerpt,
        pm.meta_value as Metadata, p.comment_count as CommentCount
		FROM wp_posts p
		LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
		LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value and pp.post_type = "attachment"
		LEFT JOIN wp_postmeta as pm ON pm.post_id = m.meta_value AND pm.meta_key = "_wp_attachment_metadata"
		WHERE (LOWER(p.post_title) like CONCAT('% ',CONVERT(LOWER(_keyword), BINARY), ' %'))
		AND p.post_type = 'post' 
		AND p.post_status = 'publish'
        ORDER BY p.post_date desc
        LIMIt _start, _end;
        
        SELECT count(*) 
        INTO TotalItems
        FROM wp_posts p 
        WHERE (LOWER(p.post_title) like CONCAT('% ',CONVERT(LOWER(_keyword), BINARY), ' %'))
		AND p.post_type = 'post' 
		AND p.post_status = 'publish'; 
	ELSE 
		SELECT p.ID, p.post_title as PostTitle, 
		ROUND(MATCH(p.post_title) AGAINST (_keyword IN NATURAL LANGUAGE MODE)) as Score,
		p.post_date as PostDate, p.post_date_gmt as PostDateGMT, p.post_content as PostContent,
        p.post_name as Slug, pp.guid as FeatureImage, 
		p.post_excerpt as PostExcerpt, pm.meta_value as Metadata, p.comment_count as CommentCount
		FROM wp_posts p
		LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
		LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value and pp.post_type = "attachment"
		LEFT JOIN wp_postmeta as pm ON pm.post_id = m.meta_value AND pm.meta_key = "_wp_attachment_metadata"
		WHERE MATCH(p.post_title, p.post_content) AGAINST (_keyword IN NATURAL LANGUAGE MODE)
		AND p.post_type = 'post' 
		AND p.post_status = 'publish'
        ORDER BY Score desc, p.post_date desc
        LIMIt _start, _end;
		
        select count(*) INTO TotalITems 
        FROM wp_posts p
        WHERE MATCH(p.post_title, p.post_content) AGAINST (_keyword IN NATURAL LANGUAGE MODE)
		AND p.post_type = 'post' 
		AND p.post_status = 'publish';
		
    END IF;
    
    
END


//
DELIMITER ;	