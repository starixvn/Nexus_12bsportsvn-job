/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_menu;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_menu`(
	_menu_name VARCHAR(255)
	 /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20230810@Hank: select custom link
    */
)
BEGIN
	SELECT p.ID as PostId, p.post_title as PostTitle
	, pl.meta_value as CateId, pp.meta_value as ParentId, t.name as CateTitle, t.slug as CateSlug
    , p1.post_title as PageTitle, p1.post_name as PageSlug, url.meta_value as CustomLink
	FROM wp_term_relationships as txr 
	INNER JOIN wp_posts as p ON txr.object_id = p.ID AND p.post_status = 'publish' AND p.post_type = 'nav_menu_item'
	LEFT JOIN wp_postmeta as pl ON p.ID = pl.post_id AND pl.meta_key = '_menu_item_object_id'
	LEFT JOIN wp_postmeta as pp ON p.ID = pp.post_id AND pp.meta_key = '_menu_item_menu_item_parent'
    LEFT JOIN wp_postmeta as url ON p.ID = url.post_id AND url.meta_key = '_menu_item_url'
    LEFT JOIN wp_terms as t ON t.term_id = pl.meta_value
    LEFT JOIN wp_posts as p1 ON p1.ID = pl.meta_value AND p1.post_status = 'publish' AND p1.post_type = "page"
    
	WHERE txr.term_taxonomy_id = (SELECT tax.term_taxonomy_id 
									FROM wp_term_taxonomy as tax 
									LEFT JOIN wp_terms as t ON tax.term_id = t.term_id 
									WHERE taxonomy = 'nav_menu' AND name = _menu_name) 
	ORDER BY p.menu_order;
END
//
DELIMITER ;	