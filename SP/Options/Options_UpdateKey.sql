/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS Options_UpdateKey;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `Options_UpdateKey`(
	IN optionKey VARCHAR(100)
    ,IN optionValue TEXT
    ,IN actorId LONG
    ,OUT errCode SMALLINT
	,OUT errMsg VARCHAR(100)
	 /*
		Creator: Hank@20230109
        Revisions: - 20230109@Hank: Init
    */
)
BEGIN
	DECLARE LogData LONGTEXT;
    
	IF (EXISTS (SELECT 1 FROM wp_options WHERE option_name = optionKey)) THEN
		UPDATE `wp_options` AS op
		SET op.option_value = optionValue
		WHERE op.option_name = optionKey 
        LIMIT 1;
	ELSE
		INSERT INTO `wp_options` (option_name, option_value)
        VALUES(optionKey, optionValue);
    END IF;
    
    SET LogData =  JSON_OBJECT('key', optionKey, 'value', optionValue);
    
    INSERT INTO `wp_Log`
	(`ActorId`,
	`ActionId`,
	`Data`,
    `LogDate`
    )
	VALUES
	(actorId,
     4,
     LogData,
     LOCALTIME()
     );
END

//
DELIMITER ;	