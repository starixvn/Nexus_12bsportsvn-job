/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS worldcup_minigame_getByUser;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `worldcup_minigame_getByUser`(
	userId BIGINT
    /*
		Creator: Hank@20221019
        Revisions:
			- 20221019@Hank: init
    */
)
BEGIN
	SELECT wm.UserId, wm.MatchId, wm.Stage, wm.TeamId, wm.UpdatedDate, wm.CreatedDate
    FROM worldcup_minigame wm
    WHERE wm.UserId = userId;
END

//
DELIMITER ;	