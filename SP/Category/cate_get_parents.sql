/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS cate_get_parents;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `cate_get_parents`(
	slug VARCHAR(255)
    /*
		Creator: Hank@20220823
        Revisions:
			- 20220823@Hank: init
    */
)
BEGIN
	DECLARE currentSlug VARCHAR(255);
    DECLARE cateId BIGINT;
    DECLARE cateName VARCHAR(255);
    DECLARE parentId BIGINT;
	DROP TEMPORARY TABLE IF EXISTS tmp_Slugs;
    CREATE TEMPORARY TABLE tmp_Slugs (Id BIGINT, Slug VARCHAR(255), CateName VARCHAR(255));
    
    SELECT t.term_id, t.slug, t.name, wtt.parent INTO cateId, currentSlug, cateName, parentId
    FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" WHERE t.slug = slug;
    
    INSERT INTO tmp_Slugs (Id, Slug, CateName)
	SELECT cateId, currentSlug, cateName;
    
    WHILE parentId != 0 DO
		SELECT t.term_id, t.slug, t.name, wtt.parent INTO cateId, currentSlug, cateName, parentId
		FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" WHERE t.term_id = parentId;
		
		INSERT INTO tmp_Slugs (Id, Slug, CateName)
		SELECT cateId, currentSlug, cateName;
    END WHILE;
    
    SELECT tmp.Id, tmp.Slug, tmp.CateName as Name FROM tmp_Slugs tmp ;
END
//
DELIMITER ;	