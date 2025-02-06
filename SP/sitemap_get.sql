DROP PROCEDURE IF EXISTS get_sitemap;
DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_sitemap`()
SQL SECURITY DEFINER
get_sitemap:BEGIN

    SELECT p.ID
          ,p.post_name As Slug
          ,p.post_type AS PostType
          ,p.post_modified_gmt AS ModifiedDate
	FROM wp_posts p 
	WHERE p.post_type IN ('post', 'page') AND post_name <> ''
    AND p.post_status = 'publish'

    UNION

    SELECT  t.term_id
           ,t.slug As Slug
           ,wtt.taxonomy
           ,NULL
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" 
    WHERE wtt.count > 0
    
    ORDER BY PostType DESC
    ,ModifiedDate DESC;
END;

//