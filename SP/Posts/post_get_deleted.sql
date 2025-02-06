/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_get_deleted;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_get_deleted`(
	fromDate DATETIME
    /*
		Creator: Hank@20240131
        Revisions:
			- 20240131@Hank: init
    */
)
BEGIN
   SELECT p.ID as PostId
   FROM wp_posts p
   WHERE p.post_type="post" AND p.post_status="trash" AND p.post_modified_gmt > fromDate;
    
END
//
DELIMITER ;	