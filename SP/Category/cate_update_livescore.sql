/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS cate_update_livescore;

DELIMITER //



CREATE DEFINER=`sabasports`@`%` PROCEDURE `cate_update_livescore`(
	IN cateId LONG,
    IN leagueId LONG,
    IN seasonId LONG,
    IN status TINYINT,
    IN actorId LONG,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
    
    /*
		Creator: Hank@20230606
        Revisions:
			- 20230606@Hank: init
    */
)
BEGIN

	DECLARE LogData LONGTEXT;
	INSERT INTO `wp_term_livescore`
	(`TermId`,
	`LeagueId`,
	`SeasonId`,
	`Status`,
	`UpdatedDate`)
	VALUES
	(cateId,
	leagueId,
	seasonId,
	status,
	UTC_TIMESTAMP)
    ON DUPLICATE KEY UPDATE 
    LeagueId = leagueId,
    SeasonId = seasonId,
    Status = status,
    UpdatedDate = UTC_TIMESTAMP;
    
    SET LogData = CONCAT('{"TermId":"', cateId, '","leagueId":"', LeagueId 
    ,'","SeasonId":"', seasonId, '","status":"', status ,'"}');
    
    INSERT INTO `wp_Log`
	(`ActorId`,
	`ActionId`,
	`Data`,
    `LogDate`
    )
	VALUES
	(actorId,
     5,
     LogData,
     UTC_TIMESTAMP()
     );
    
    

END

//
DELIMITER ;	