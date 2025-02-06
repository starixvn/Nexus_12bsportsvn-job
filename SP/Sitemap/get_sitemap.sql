/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_sitemap;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_sitemap`(
	/*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20220805@Hank: add cate parent field
    */
)
get_sitemap:BEGIN

    SELECT p.ID
          ,p.post_name As Slug
          ,p.post_type AS PostType
          ,p.post_modified_gmt AS ModifiedDate
          ,NULL as Parent
	FROM wp_posts p 
	WHERE p.post_type = 'post' AND post_name <> ''
    AND p.post_status = 'publish'
    AND p.post_modified_gmt > '2020-12-31'
    

    UNION

    SELECT  t.term_id
           ,t.slug As Slug
           ,wtt.taxonomy
           ,NULL
           ,wtt.parent
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category"
    WHERE t.slug != 'uncategorized'
    ORDER BY PostType DESC
    ,ModifiedDate DESC;
END

//
DELIMITER ;	