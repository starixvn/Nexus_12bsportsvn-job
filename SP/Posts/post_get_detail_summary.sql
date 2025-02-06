/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_detail_summary;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_detail_summary`(
    slug varchar(200), 
    PostType varchar (30)
    
    /*
		Creator: Hank@20230818
        Revisions:	- 20230818@Hank: init
    */
)
BEGIN
    
	SELECT p.ID, p.post_name as Slug FROM wp_posts p WHERE p.post_name = Slug  AND p.post_status = 'publish' AND p.post_type = PostType;
	
END
//
DELIMITER ;	