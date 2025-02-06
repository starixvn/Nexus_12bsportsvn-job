/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS Options_GetKey;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `Options_GetKey`(
	optionKey VARCHAR(100)
    /*
		Creator: Hank@20230109
        Revisions: - 20230109@Hank: Init
    */
)
BEGIN
	SELECT op.option_name as OptionName, op.option_value as OptionValue FROM wp_options op WHERE op.option_name = optionKey LiMIT 1;
END

//
DELIMITER ;	