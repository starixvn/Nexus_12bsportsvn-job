/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_view_statistic_get;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_view_statistic_get`(
	fromDate DATE,
    toDate DATE
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20240906@Hank: check statistic for video article
    */
)
BEGIN
    DECLARE videoCategoryId INT;
    SELECT t.term_id INTO videoCategoryId
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" 
    WHERE t.slug = 'video' LIMIT 1;

    DROP TEMPORARY TABLE IF EXISTS tmpVideoChilds;
    CREATE TEMPORARY TABLE tmpVideoChilds(CategoryId INT);

    INSERT INTO tmpVideoChilds(CategoryId)
    SELECT  wtt.term_id
    FROM wp_term_taxonomy as wtt 
    WHERE wtt.taxonomy = "category" AND (wtt.term_id = videoCategoryId OR wtt.parent = videoCategoryId);
    
	INSERT INTO tmpVideoChilds(CategoryId)
    SELECT  wtt.term_id
    FROM wp_term_taxonomy as wtt 
    WHERE wtt.taxonomy = "category" AND wtt.parent IN (SELECT wtt1.term_id FROM wp_term_taxonomy as wtt1 WHERE wtt1.parent = videoCategoryId);

    DROP TEMPORARY TABLE IF EXISTS tmpPosts;
    CREATE TEMPORARY TABLE tmpPosts(PostId BIGINT UNSIGNED, PostDate DATE, IsVideoPost BIT);
    INSERT INTO tmpPosts(PostId, PostDate, IsVideoPost)
    SELECT DISTINCT p.ID 
                    ,p.post_date 
                    ,(CASE WHEN tt.term_id IN (SELECT CategoryId FROM tmpVideoChilds) THEN 1 ELSE 0 END) As IsVideo
    FROM wp_posts p
    INNER JOIN wp_term_relationships tr ON p.ID = tr.object_id
    INNER JOIN wp_term_taxonomy tt ON tt.term_taxonomy_id = tr.term_taxonomy_id and tt.taxonomy = 'category'
    WHERE p.post_status = 'publish' AND p.post_type = 'post'
    AND DATE(p.post_date) BETWEEN fromDate  AND toDate;

    
    SELECT p.PostDate as PostDate
          ,COUNT(DISTINCT IF (p.IsVideoPost = 0, p.PostId, NULL)) AS PostCount
          ,SUM(CASE WHEN p.IsVideoPost = 0 THEN IFNULL(pd.view_count, 0) ELSE 0 END) AS PostView
          ,COUNT(DISTINCT IF (p.IsVideoPost = 1, p.PostId, NULL)) AS VideoCount
          ,SUM(CASE WHEN p.IsVideoPost = 1 THEN IFNULL(pd.video_view, 0) ELSE 0 END) AS VideoView
    FROM tmpPosts p 
    LEFT JOIN wp_postview_details pd ON p.PostId = pd.post_id
    GROUP BY p.PostDate
    ORDER BY p.PostDate;
    
    DROP TEMPORARY TABLE IF EXISTS tmpPosts;
    DROP TEMPORARY TABLE IF EXISTS tmpVideoChilds;
END
//
DELIMITER ;	