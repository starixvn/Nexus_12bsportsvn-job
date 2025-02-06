/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_page_detail_by_slug;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_page_detail_by_slug`(
	Slug varchar(255)
	/*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20230519@Hank: migrate rank math to yoast plugin
    */
)
BEGIN
	SELECT p.post_title as title, p.ID as CateId
    , yi.title as SEOTitle, yi.description as description
	, yi.open_graph_title as OgTitle, yi.open_graph_description as OgDescription, yi.open_graph_image as OgImage
	FROM wp_posts p 
    LEFT JOIN wp_yoast_indexable yi ON yi.object_id = p.ID AND yi.object_type = "post" AND yi.object_sub_type = "page"
	where p.post_name = Slug AND p.post_type = "page";
END
//
DELIMITER ;	