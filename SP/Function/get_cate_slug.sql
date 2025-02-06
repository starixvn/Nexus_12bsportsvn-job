/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="1" isNested="0"></info>*/
DROP FUNCTION IF EXISTS get_cate_slug;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` FUNCTION `get_cate_slug`(
	slug1 VARCHAR(255),
	slug2 VARCHAR(255),
    slug3 VARCHAR(255)
	/*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
    */
) RETURNS varchar(255) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
    DETERMINISTIC
BEGIN
	DECLARE mainSlug VARCHAR(255);
    DECLARE parentId INT;
    IF (slug2 IS NULL AND slug3 IS NULL) THEN
		SELECT t.slug INTO mainSlug
        FROM wp_terms t 
        INNER JOIN wp_term_taxonomy wt ON wt.term_id = t.term_id  AND taxonomy = "category" 
        WHERE t.slug = slug1 AND (wt.parent = 175 OR wt.parent = 0);
    END IF;
    IF slug2 IS NOT NULL THEN
		SELECT t.term_id INTO parentId
        FROM wp_terms t 
        INNER JOIN wp_term_taxonomy wt ON wt.term_id = t.term_id  AND taxonomy = "category" 
        WHERE t.slug = slug1;
        
        SELECT t.slug
        INTO mainSlug
        FROM wp_terms t 
        INNER JOIN wp_term_taxonomy wt ON wt.term_id = t.term_id  AND taxonomy = "category" 
        WHERE t.slug = slug2 AND wt.parent = parentId;
        
        IF slug3 IS NOT NULL AND mainSlug IS NOT NULL THEN
			SET mainSlug = null;
			SELECT t.term_id INTO parentId
			FROM wp_terms t 
			INNER JOIN wp_term_taxonomy wt ON wt.term_id = t.term_id  AND taxonomy = "category" 
			WHERE t.slug = slug2;
			
			SELECT t.slug
			INTO mainSlug
			FROM wp_terms t 
			INNER JOIN wp_term_taxonomy wt ON wt.term_id = t.term_id  AND taxonomy = "category" 
			WHERE t.slug = slug3 AND wt.parent = parentId;
		END IF;
	END IF;
    
    
	RETURN mainSlug;
END
//
DELIMITER ;	