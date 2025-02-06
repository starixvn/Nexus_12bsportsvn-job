/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="1" isNested="0"></info>*/

DROP FUNCTION IF EXISTS get_sub_cate;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` FUNCTION `get_sub_cate`(
	slug VARCHAR(255)
    /*
		Creator: Hank@20220823
        Revisions:
			- 20220823@Hank: init
    */
) RETURNS json
    DETERMINISTIC
BEGIN
	DECLARE category INT;
    DECLARE cateCount INT;
    DECLARE result JSON;
	SELECT t.term_id INTO category FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" WHERE t.slug = slug;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_Cate;
    CREATE TEMPORARY TABLE tmp_Cate (term_id BIGINT, slug VARCHAR(255), term_taxonomy_id BIGINT);
    
    DROP TEMPORARY TABLE IF EXISTS tmp_CateSub;
    CREATE TEMPORARY TABLE tmp_CateSub (term_id BIGINT);
    
    DROP TEMPORARY TABLE IF EXISTS tmp;
    CREATE TEMPORARY TABLE tmp (term_id BIGINT);
    
	INSERT INTO tmp_Cate (term_id, slug, term_taxonomy_id)
    SELECT t.term_id, t.slug, wtt.term_taxonomy_id
    FROM wp_terms t
    INNER JOIN wp_term_taxonomy as wtt ON wtt.term_id = t.term_id AND wtt.taxonomy = "category" 
    WHERE wtt.term_id = category OR wtt.parent = category;
    
    SELECT count(*) INTO cateCount FROM tmp_Cate;
    
    INSERT INTO tmp_CateSub (term_id)
	SELECT t.term_id
	FROM tmp_Cate t;
    
    WHILE cateCount > 0 DO
        INSERT INTO tmp_Cate (term_id, slug, term_taxonomy_id)
		SELECT t.term_id, t.slug, wtt.term_taxonomy_id
		FROM wp_terms t
		INNER JOIN wp_term_taxonomy as wtt ON wtt.term_id = t.term_id AND wtt.taxonomy = "category" 
		WHERE wtt.parent IN (SELECT sub.term_id FROM tmp_CateSub sub);
        
		DROP TEMPORARY TABLE IF EXISTS tmp;
		CREATE TEMPORARY TABLE tmp (term_id BIGINT);
		INSERT INTO tmp (term_id)
        SELECT wtt.term_id
		FROM wp_term_taxonomy as wtt
		WHERE wtt.parent IN (SELECT sub.term_id FROM tmp_CateSub sub);
        
        DROP TEMPORARY TABLE IF EXISTS tmp_CateSub;
		CREATE TEMPORARY TABLE tmp_CateSub (term_id BIGINT);
        INSERT INTO tmp_CateSub
        SELECT tmp.term_id
        FROM tmp;
        
        SELECT count(*) INTO cateCount FROM tmp_CateSub;
   END WHILE;  
   
   SELECT JSON_ARRAYAGG(JSON_OBJECT('term_id', t.term_id, 'slug', t.slug, 'term_taxonomy_id', t.term_taxonomy_id)) INTO result 
   FROM ( SELECT DISTINCT c.term_id, c.slug, c.term_taxonomy_id  from tmp_Cate as c) as t;
   return result;
END

//
DELIMITER ;	