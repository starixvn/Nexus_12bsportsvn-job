/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS Options_CountValueKey;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `Options_CountValueKey`(
	optionKey VARCHAR(100)
    ,OUT errCode SMALLINT
	,OUT errMsg VARCHAR(100)
    /*
		Creator: Hank@20240201
        Revisions: - 20240201@Hank: Init
    */
)
BEGIN

	IF (EXISTS (SELECT 1 FROM wp_options WHERE option_name = optionKey)) THEN
		UPDATE `wp_options` AS op
		SET op.option_value = op.option_value + 1
		WHERE op.option_name = optionKey 
        LIMIT 1;
	ELSE
		INSERT INTO `wp_options` (option_name, option_value)
        VALUES(optionKey, 1);
    END IF;
END

//
DELIMITER ;	