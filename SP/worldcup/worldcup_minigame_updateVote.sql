/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS worldcup_minigame_updateVote;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `worldcup_minigame_updateVote`(
	IN userId BIGINT,
    IN matchId BIGINT,
    IN stage SMALLINT,
    IN teamId BIGINT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
	/*
		Creator: Hank@20221019
        Revisions:
			- 20221019@Hank: init
    */
)
BEGIN
	INSERT INTO `worldcup_minigame`
	(`UserId`,
	`MatchId`,
	`Stage`,
	`TeamId`,
	`CreatedDate`,
    `UpdatedDate`)
	VALUES
	(userId,
	matchId,
	stage,
	teamId,
	now(),
    now())
    ON DUPLICATE KEY UPDATE
    TeamId = teamId,
    UpdatedDate = now();

END

//
DELIMITER ;	