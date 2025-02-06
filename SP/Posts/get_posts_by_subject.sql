/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_posts_by_subject;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_subject`(	
	/*
		Creator: Brian@20220913
        Revisions:
			- 20220913@Brian: init
            - 20240130@Hank: add param startItem, Limit
    */
    _categorySlug VARCHAR(200),
    _categoryType INT,
    _subjectType INT,
	_fromDate DATETIME,
    _startItem INT,
    _rowLimit INT
)
BEGIN
	DECLARE count  INT;
	DECLARE category INT;
    DECLARE cate_name VARCHAR(200);
    DECLARE cate_parent_name VARCHAR(200);
    DECLARE cate_parent INT;
    DECLARE result JSON;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Terms;
    CREATE TEMPORARY TABLE tmp_Terms (term_id BIGINT, slug VARCHAR(255) primary key, term_taxonomy_id BIGINT);
    
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
    
	
	SELECT p.id AS PostId, p.post_title AS Title, CONVERT_TZ(p.post_date_gmt,'+00:00', '+08:00')  AS PublishDate,
		pp.guid as Image, _categoryType AS Category
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE  p.post_status = 'publish' AND  p.post_date_gmt > _fromDate
		AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN tmp_Cate as c ON c.term_taxonomy_id = tr.term_taxonomy_id)
	ORDER BY p.post_date DESC
    LIMIT _startItem, _rowLimit;	
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Terms;
    
END

//
DELIMITER ;	