/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS cate_get_livescore;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `cate_get_livescore`(
	/*
		Creator: Hank@20230606
        Revisions:
			- 20230606@Hank: init
    */
)
BEGIN
	SELECT tl.TermId as CateId, tl.Status
    , tl.LeagueId, l.LeagueNameVN, l.LeagueNameEN, l.LeagueFullNameEN, l.Icon, l.IconVN, l.CurrentSeasonId
    FROM wp_term_livescore tl
    LEFT JOIN livescore_league l ON l.LeagueId = tl.LeagueId;
END

//
DELIMITER ;	