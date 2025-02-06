/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS worldcup_minigame_getVoteMatch;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `worldcup_minigame_getVoteMatch`(
	IN matchId BIGINT
     /*
		Creator: Hank@20222010
        Revisions:
			- 20222010@Hank: init
            - 20240608@Hank: add more livescore data
    */
)
BEGIN
     SELECT m.MatchId
        ,COALESCE(mc.StartTime, m.StartTime) as StartTime
        ,COALESCE(mc.Status, m.Status) as Status,
        m.LeagueId, m.SeasonId, m.StageId
    FROM livescore_match m
        LEFT JOIN livescore_match_custom mc ON mc.MatchId = m.matchId
    WHERE m.MatchId = matchId AND m.Status IS NOT NULL AND m.CombinedId IS NULL
		AND NOT EXISTS (SELECT md.MatchId FROM livescore_match_deleted md WHERE m.MatchId = md.MatchId);
END

//
DELIMITER ;	