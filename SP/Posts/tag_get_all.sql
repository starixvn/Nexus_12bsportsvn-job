/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS tag_get_all;

DELIMITER //



CREATE DEFINER=`sabasports`@`%` PROCEDURE `tag_get_all`(
	 /*
		Creator: Hank@20230614
        Revisions:
			- 20230614@Hank: init
    */
)
BEGIN
	SELECT wt.term_id as CateId, wt.name as Name, wt.slug as Slug
    FROM wp_terms wt
    INNER JOIN wp_term_taxonomy wtt ON wtt.term_id = wt.term_id AND wtt.taxonomy = "post_tag"
    ORDER BY wtt.count desc;
END

//
DELIMITER ;	