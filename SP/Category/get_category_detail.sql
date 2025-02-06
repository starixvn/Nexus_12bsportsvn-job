/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS get_category_detail;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_category_detail`(
	slug varchar(255)
	/*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20230519@Hank: migrate rank math to yoast plugin
            - 20230606@Hank: select league
            - 20230810@Hank: select currentSeasonId
            - 20240408@Hank: select custom schema.org
    */
)
BEGIN
	DECLARE cateId INT;
    DECLARE seasonId BIGINT;
    DECLARE leagueId BIGINT;
    
    SELECT t.term_id INTO cateId 
    FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" WHERE t.slug = slug;
    
    SELECT l.LeagueId, l.CurrentSeasonId INTO leagueId, seasonId 
    FROM wp_term_livescore tl 
    INNER JOIN livescore_league l ON l.LeagueId = tl.LeagueId
    WHERE tl.TermId = CateId AND tl.LeagueId > 0 AND tl.Status = 1;
    
	SELECT  t.name as Title , t.term_id as CateId, t.slug as Slug
		,yi.title as SEOTitle, yi.description as description
        ,yi.open_graph_title as OgTitle, yi.open_graph_description as OgDescription, yi.open_graph_image as OgImage
        ,tm.meta_value as CustomSchema
        ,leagueId, seasonId
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wt ON  t.term_id = wt.term_id AND wt.taxonomy = "category"
    LEFT JOIN wp_termmeta tm ON t.term_id = tm.term_id AND tm.meta_key = "saswp_custom_schema_field"
    LEFT JOIN wp_yoast_indexable yi ON yi.object_id = t.term_id AND yi.object_type = "term" AND yi.object_sub_type = "category"
    WHERE t.slug = slug;
END

//
DELIMITER ;	