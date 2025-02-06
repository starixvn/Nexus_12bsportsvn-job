/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS post_view_detail_get;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `post_view_detail_get`(
	createdDate DATE,
    isVideo BIT,
    viewSortType VARCHAR(10),
    authorSortType VARCHAR(10),
    pageIndex INT,
    pageSize INT,
    OUT totalItems INT,
    OUT totalViews INT
    /*
		Creator: Hank@20220720
        Revisions:
			- 20220720@Hank: init
            - 20240906@Hank: check statistic for video article
    */
)
BEGIN
    DECLARE startIndex INT DEFAULT 0;
    DECLARE videoCategoryId INT;

    SELECT (pageIndex - 1) * pageSize INTO startIndex;
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
    CREATE TEMPORARY TABLE tmpPosts(PostId BIGINT(20));
    INSERT INTO tmpPosts(PostId) 
    SELECT DISTINCT  p.ID
    FROM wp_posts p 
    INNER JOIN wp_term_relationships tr ON p.ID = tr.object_id
    INNER JOIN wp_term_taxonomy tt ON tt.term_taxonomy_id = tr.term_taxonomy_id and tt.taxonomy = 'category'
    WHERE p.post_status = 'publish' AND p.post_type = 'post'
    AND DATE(p.post_date) = createdDate
    AND isVideo = (CASE 
            WHEN tt.term_id IN (SELECT CategoryId FROM tmpVideoChilds) 
            THEN 1 ELSE 0 END);
	
    SELECT COUNT(*) FROM tmpPosts INTO totalItems; 

    SELECT SUM(CASE WHEN isVideo = 1 THEN pd.video_view ELSE pd.view_count END)
    FROM tmpPosts tmp_p
    INNER JOIN wp_posts p ON tmp_p.PostId = p.ID
    LEFT JOIN wp_postview_details pd ON tmp_p.PostId = pd.post_id
    INTO totalViews; 

    SELECT tmp_p.PostId
          ,p.post_title As Title
          ,p.post_name As Slug
          ,p.post_date As CreatedDate
          ,u.display_name as Author
          ,SUM(CASE WHEN isVideo = 1 THEN pd.video_view ELSE pd.view_count END) As TotalViews
    FROM tmpPosts tmp_p
    INNER JOIN wp_posts p ON tmp_p.PostId = p.ID
    INNER JOIN wp_users u ON u.ID = p.post_author
    LEFT JOIN wp_postview_details pd ON tmp_p.PostId = pd.post_id
    GROUP BY tmp_p.PostId
    ORDER BY CASE WHEN viewSortType = 'desc' THEN SUM(CASE WHEN isVideo = 1 THEN pd.video_view ELSE pd.view_count END) END DESC
			 ,CASE WHEN viewSortType = 'asc' THEN SUM(CASE WHEN isVideo = 1 THEN pd.video_view ELSE pd.view_count END) END
             ,CASE WHEN authorSortType = 'desc' THEN u.display_name END desc
             ,CASE WHEN authorSortType = 'asc' THEN u.display_name END
             ,p.post_date DESC
    LIMIT startIndex, pageSize;

    DROP TEMPORARY TABLE IF EXISTS tmpVideoChilds;
    DROP TEMPORARY TABLE IF EXISTS tmpPosts;
END
//
DELIMITER ;	