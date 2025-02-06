/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_api_recent_posts;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_api_recent_posts`(
	_categoryType INT,
	_fromDate DATETIME,
    _startItem INT,
    _rowLimit INT
    /*
		Creator: Hank@20230130
        Revisions:
			- 20230130@Hank: init
    */
)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    CREATE TEMPORARY TABLE tmp_PostIds (PostId BIGINT PRIMARY KEY);
    	
    INSERT INTO tmp_PostIds (PostId)
    SELECT p.id
    FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish'  AND p.post_date_gmt > _fromDate
	AND ID NOT IN (SELECT tr.object_id FROM wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "post_format"
                    INNER JOIN wp_terms as t ON t.term_id = tt.term_id AND t.slug = "post-format-video")
	ORDER BY p.post_date DESC
	LIMIT _startItem, _rowLimit;
    
	SELECT p.id AS PostId, p.post_title AS Title, CONVERT_TZ(p.post_date_gmt,'+00:00', '+08:00')  AS PublishDate,
		pp.guid as Image, _categoryType AS Category
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE  p.ID IN (SELECT tmp.PostId FROM tmp_PostIds tmp)
	ORDER BY p.post_date DESC;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_PostIds;
    
END
//
DELIMITER ;	