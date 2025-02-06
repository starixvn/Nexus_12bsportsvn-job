/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/

DROP PROCEDURE IF EXISTS worldcup_minigame_get_by_stage;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `worldcup_minigame_get_by_stage`(
	stage SMALLINT
	/*
		Creator: Brian@20221023
        Revisions:
			- 20221023@Brian: init
    */
)
BEGIN
	SELECT m.UserId, m.MatchId, m.Stage, m.TeamId, m.CreatedDate, m.UpdatedDate, u.display_name AS UserName, m4.meta_value AS Icon
	FROM sabasports.worldcup_minigame AS m 
		INNER JOIN sabasports.wp_users AS u ON m.UserId=u.ID 
		LEFT JOIN wp_usermeta AS m4 ON m4.user_id = m.UserId AND m4.meta_key = 'photo' 
	WHERE m.Stage = stage;
END

//
DELIMITER ;	