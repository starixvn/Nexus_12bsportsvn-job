/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS poll_get_all;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `poll_get_all`(
	/*
		Creator: Hank@20240307
        Revisions: - 20240307@Hank: init
    */
)
BEGIN
	SELECT id, name, question  FROM wp_polls_question;
END

//
DELIMITER ;	