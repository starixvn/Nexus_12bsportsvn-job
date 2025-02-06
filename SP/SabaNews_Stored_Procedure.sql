DROP PROCEDURE IF EXISTS check_type_category;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `check_type_category`( _parent varchar(200), _ID INT)
BEGIN
	DECLARE parentId INT;
    SET parentId = (SELECT t.term_id FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND wtt.taxonomy = "category" WHERE t.slug = _parent );
	SELECT  t_t.term_id
	FROM wp_term_taxonomy as t_t
	WHERE t_t.parent = parentId 
	AND t_t.term_id IN (SELECT t_t.term_id 
						FROM wp_term_taxonomy as t_t 
						INNER JOIN wp_term_relationships t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id AND t_r.object_id = _ID);
END


//
DELIMITER ;	


DROP PROCEDURE IF EXISTS cmt_create;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `cmt_create`(
	commentPostID BIGINT(20),
    commentAuthor VARCHAR(100),
    commentAuthorEmail VARCHAR(200),
    commentAuthorIP VARCHAR(100),
    commentDate DATETIME,
    commentDateGMT DATETIME,
    commentContent TEXT,
    commentAgent VARCHAR(255),
    commentParent BIGINT(20),
    userID BIGINT(20),
    OUT CommentID BIGINT(20),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	DECLARE totalComments INT;
    
	INSERT INTO `wp_comments`
	(`comment_post_ID`,
	`comment_author`,
	`comment_author_email`,
	`comment_author_IP`,
	`comment_date`,
	`comment_date_gmt`,
	`comment_content`,
	`comment_approved`,
	`comment_agent`,
	`comment_type`,
	`comment_parent`,
	`user_id`)
	VALUES
	(commentPostID,
	commentAuthor,
	commentAuthorEmail,
	commentAuthorIP,
	commentDate,
	commentDateGMT,
	commentContent,
	"1",
	commentAgent,
	"comment",
	commentParent,
	userID);
    
    SET CommentID = LAST_INSERT_ID();
    
    INSERT INTO `wp_commentmeta`
	(`comment_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(CommentID,
	'cld_like_count',
	0);
    
     INSERT INTO `wp_commentmeta`
	(`comment_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(CommentID,
	'comment_users',
	'');
    
     INSERT INTO `wp_commentmeta`
	(`comment_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(CommentID,
	'comment_ips',
	'');
    
    SELECT count(*)
    INTO totalComments
	FROM wp_comments cm
	WHERE cm.comment_post_ID = commentPostID AND cm.comment_approved = "1" AND cm.comment_type = "comment";
    
    UPDATE `wp_posts`
	SET
	`comment_count` = totalComments
	WHERE `ID` = commentPostID;
        
    SET ErrCode = 0,
		ErrMsg = 'Update data successfully';
END


//
DELIMITER ;	


DROP PROCEDURE IF EXISTS cmt_get_children;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `cmt_get_children`(
	PostID INT,
    CmtID INT
)
BEGIN
	SELECT cm.comment_ID, cm.comment_post_ID, cm.comment_author, cm.comment_author_email, cm.comment_author_IP, cm.comment_date, cm.comment_date_gmt, 
    cm.comment_content, cm.comment_parent, cm.user_id, m1.meta_value as comment_like_count, m2.meta_value as comment_like_ips, m3.meta_value as comment_like_users, um.meta_value as Photo
    FROM wp_comments cm
    LEFT JOIN wp_commentmeta m1 ON m1.comment_id = cm.comment_ID AND m1.meta_key = 'cld_like_count'
    LEFT JOIN wp_commentmeta m2 ON m2.comment_id = cm.comment_ID AND m2.meta_key = 'comment_ips'
    LEFT JOIN wp_commentmeta m3 ON m3.comment_id = cm.comment_ID AND m3.meta_key = 'comment_users'
	LEFT JOIN wp_usermeta um ON um.user_id = cm.user_id AND um.meta_key = 'photo'
    WHERE cm.comment_post_ID = PostID AND cm.comment_parent = CmtID AND cm.comment_type = "comment" AND cm.comment_approved = "1";
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS cmt_get_like_data_cmtId;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `cmt_get_like_data_cmtId`(CommentID BIGINT(20))
BEGIN
		select m1.meta_value as comment_like_count, m2.meta_value as comment_like_users, m3.meta_value as comment_like_ips
        from wp_commentmeta m1 
        LEFT JOIN wp_commentmeta m2 ON m2.comment_id = m1.comment_id AND m2.meta_key = 'comment_users'
        LEFT JOIN wp_commentmeta m3 ON m3.comment_id = m1.comment_id AND m3.meta_key = 'comment_ips'
        where m1.comment_id = CommentID AND m1.meta_key  = 'cld_like_count';
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS cmt_get_parent_and_number_children;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `cmt_get_parent_and_number_children`(
	PostID INT,
    FilterType varchar(50),
    Start INT,
    End INT,
    OUT TotalItems INT,
    OUT TotalParentCmt INT
)
BEGIN
	DECLARE checkorder varchar(100);
    SET checkorder = 'desc';
	SELECT count(*)
    INTO TotalItems
	FROM wp_comments cm
	WHERE cm.comment_post_ID = PostID AND cm.comment_approved = "1" AND cm.comment_type = "comment";
    
    SELECT count(*)
    INTO TotalParentCmt
	FROM wp_comments cm
	WHERE cm.comment_post_ID = PostID AND cm.comment_approved = "1" AND cm.comment_type = "comment" AND cm.comment_parent = 0;
    
    
	SELECT cm.comment_ID, cm.comment_post_ID, cm.comment_author, cm.comment_author_email, cm.comment_author_IP, cm.comment_date, cm.comment_date_gmt
    , cm.comment_content, cm.comment_parent, cm.user_id, m1.meta_value as comment_like_count, m2.meta_value as comment_like_ips, m3.meta_value as comment_like_users
	,(SELECT count(*) FROM wp_comments cm1 where cm1.comment_parent = cm.comment_ID AND cm1.comment_approved = "1") as comment_number_children,
    um.meta_value as Photo
	FROM wp_comments cm
    LEFT JOIN wp_commentmeta m1 ON m1.comment_id = cm.comment_ID AND m1.meta_key = 'cld_like_count'
    LEFT JOIN wp_commentmeta m2 ON m2.comment_id = cm.comment_ID AND m2.meta_key = 'comment_ips'
    LEFT JOIN wp_commentmeta m3 ON m3.comment_id = cm.comment_ID AND m3.meta_key = 'comment_users'
    LEFT JOIN wp_usermeta um ON um.user_id = cm.user_id AND um.meta_key = 'photo'
	WHERE cm.comment_post_ID = PostID AND cm.comment_approved = "1" AND cm.comment_type = "comment" AND cm.comment_parent = 0
    ORDER BY
    CASE FilterType WHEN 'time' THEN cm.comment_date ELSE comment_like_count END DESC, cm.comment_date desc
    LIMIT Start, End;
    
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS cmt_update_like;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `cmt_update_like`(
	commentID BIGINT(20),
    commentLikeCount BIGINT(20),
    commentLikeIPs LONGTEXT,
    commentLikeUsers LONGTEXT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	
    declare checkLikeCount INT;
    declare checkUser INT;
    declare checkIP INT;
    select count(*) INTO checkLikeCount from wp_commentmeta where meta_key = 'cld_like_count' AND comment_id = commentID;
    select count(*) INTO checkUser from wp_commentmeta where meta_key = 'comment_users' AND comment_id = commentID;
    select count(*) INTO checkIP from wp_commentmeta where meta_key = 'comment_ips' AND comment_id = commentID;
    
    
    IF checkLikeCount > 0 THEN
		UPDATE `wp_commentmeta`
		SET
		`meta_value` = commentLikeCount
		WHERE `meta_key` = 'cld_like_count' AND `comment_id` = commentID;
    ELSE
         INSERT INTO `wp_commentmeta`
		(`comment_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(CommentID,
		'cld_like_count',
		commentLikeCount);
    END IF;
    
    IF checkUser > 0 THEN
		UPDATE `wp_commentmeta`
		SET
		`meta_value` = commentLikeUsers
		WHERE `meta_key` = 'comment_users' AND `comment_id` = commentID;
    ELSE
		 INSERT INTO `wp_commentmeta`
		(`comment_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(CommentID,
		'comment_users',
		commentLikeUsers);
    END IF;
	
    IF checkIP > 0 THEN
		UPDATE `wp_commentmeta`
		SET
		`meta_value` = commentLikeIPs
		WHERE `meta_key` = 'comment_ips' AND `comment_id` = commentID;
    ELSE
		INSERT INTO `wp_commentmeta`
		(`comment_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(CommentID,
		'comment_ips',
		commentLikeUsers);
    END IF;
   
    SET ErrCode = 0,
		ErrMsg = 'Update data successfully';
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS get_category_detail;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_category_detail`(_slug varchar(50))
get_category_detail:BEGIN
	SELECT  t.name as title , t.term_id, t.slug
		,(SELECT meta_value FROM wp_termmeta tm1  WHERE  meta_key = "rank_math_description" AND tm1.term_id = t.term_id) as description
        ,(SELECT meta_value FROM wp_termmeta tm2  WHERE  meta_key = "rank_math_facebook_image" AND tm2.term_id = t.term_id) as og_image
        ,(SELECT meta_value FROM wp_termmeta tm3  WHERE  meta_key = "rank_math_facebook_description" AND tm3.term_id = t.term_id) as og_description
        ,(SELECT meta_value FROM wp_termmeta tm4  WHERE  meta_key = "rank_math_facebook_title" AND tm4.term_id = t.term_id) as og_title
        ,(SELECT meta_value FROM wp_termmeta tm5  WHERE  meta_key = "rank_math_title" AND tm5.term_id = t.term_id) as seo_title
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wt ON  t.term_id = wt.term_id AND wt.taxonomy = "category"
    WHERE t.slug = _slug;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS get_menu;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_menu`(_menu_name VARCHAR(50))
get_menu:BEGIN
	SELECT p.ID, p.post_title, pl.meta_value as term_id, pp.meta_value as menu_parent, t.name as cate_title, t.slug as slug, p1.post_name as page_slug
	FROM wp_term_relationships as txr 
	INNER JOIN wp_posts as p ON txr.object_id = p.ID AND p.post_status = 'publish' AND p.post_type = 'nav_menu_item'
	LEFT JOIN wp_postmeta as pl ON p.ID = pl.post_id AND pl.meta_key = '_menu_item_object_id'
	LEFT JOIN wp_postmeta as pp ON p.ID = pp.post_id AND pp.meta_key = '_menu_item_menu_item_parent'
    LEFT JOIN wp_terms as t ON t.term_id = pl.meta_value
    LEFT JOIN wp_posts as p1 ON p1.ID = pl.meta_value AND p1.post_status = 'publish' AND p1.post_type = "page"
    
	WHERE txr.term_taxonomy_id = (SELECT t.term_id 
									FROM wp_term_taxonomy as tax 
									LEFT JOIN wp_terms as t ON tax.term_id = t.term_id 
									WHERE taxonomy = 'nav_menu' AND name = _menu_name) 
	ORDER BY p.menu_order;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS get_page_detail_by_slug;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_page_detail_by_slug`(Slug varchar(50))
get_page_detail_by_slug:BEGIN
	SELECT p.post_title as title, p.ID as term_id
    ,(SELECT meta_value FROM wp_postmeta pm1  WHERE  meta_key = "rank_math_title" AND pm1.post_id = p.ID) as seo_title
	,(SELECT meta_value FROM wp_postmeta pm2  WHERE  meta_key = "rank_math_description" AND pm2.post_id = p.ID) as description
    ,(SELECT meta_value FROM wp_postmeta pm3  WHERE  meta_key = "rank_math_facebook_image" AND pm3.post_id = p.ID) as og_image
	,(SELECT meta_value FROM wp_postmeta pm4  WHERE  meta_key = "rank_math_facebook_description" AND pm4.post_id = p.ID) as og_description
	,(SELECT meta_value FROM wp_postmeta pm5  WHERE  meta_key = "rank_math_facebook_title" AND pm5.post_id = p.ID) as og_title
	FROM wp_posts p 
	where p.post_name = Slug AND p.post_type = "page";
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS get_post_detail_by_slug;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_post_detail_by_slug`(Slug varchar(200), PostType varchar (30))
BEGIN
	DECLARE PostId varchar(100);
	DECLARE tags varchar(600);
    DECLARE tagsSlug varchar(600);
    DECLARE cate_name varchar(600);
    DECLARE cate_id varchar(600);
    DECLARE categoriesSlug varchar(600);
    DECLARE checkViews INT;
    
    SELECT p.ID INTO  PostId FROM wp_posts p where p.post_name = Slug AND p.post_status = 'publish' AND p.post_type = PostType ;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.slug separator ', ')
    INTO tags, tagsSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'post_tag'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE  t_r.object_id = PostId;
    
    SELECT group_concat(t.name separator ', '), group_concat(t.term_id separator ', '), group_concat(t.slug separator ', ')
    INTO cate_name, cate_id, categoriesSlug
	FROM wp_terms as t
	INNER JOIN wp_term_taxonomy as t_t ON t_t.term_id = t.term_id AND taxonomy = 'category'
	INNER JOIN wp_term_relationships as t_r ON t_r.term_taxonomy_id = t_t.term_taxonomy_id
	WHERE t_r.object_id = PostId;
    
	SELECT p.ID, p.post_title, p.post_date, p.post_date_gmt, p.post_content, p.post_excerpt, p.post_name, pp.guid as feature_image, m1.meta_value as metadata, p.comment_count, tags, tagsSlug, cate_name as CatesName, cate_id, categoriesSlug
    FROM wp_posts p
    LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
    WHERE p.ID = PostId AND p.post_status = 'publish';
    
    IF PostType = "post" AND postId is not null THEN
		select count(*) INTO checkViews from wp_postmeta where post_id = postId and meta_key = "trx_addons_post_views_count";
        
        IF(checkViews > 0) THEN
			UPDATE wp_postmeta 
			SET meta_value = meta_value + 1
			WHERE post_id = postId AND meta_key = "trx_addons_post_views_count";
		ELSE 
			INSERT INTO `wp_postmeta`
			(`post_id`,
			`meta_key`,
			`meta_value`)
			VALUES
			(postId,
			'trx_addons_post_views_count',
			1);
		END IF;
        
    END IF;
END
//
DELIMITER ;	


DROP PROCEDURE IF EXISTS get_posts_by_cate_slug;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_cate_slug`(
	_categorySlug varchar(200),
    _start INT,
    _end INT,
    OUT TotalItems int  
)
BEGIN
	DECLARE count  INT;
	DECLARE category INT;
    DECLARE cate_name VARCHAR(200);
    DECLARE cate_parent_name VARCHAR(200);
    DECLARE cate_parent INT;
    
    SELECT t.term_id, t.name, wtt.parent INTO category, cate_name, cate_parent 
    FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" WHERE slug = _categorySlug;
    
    IF cate_parent is not null and cate_parent != 175 THEN
		SELECT name INTO cate_parent_name FROM wp_terms where term_id = cate_parent;
    END IF;
    
    
	SELECT count(p.id)
	INTO TotalItems
	FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
					WHERE tt.term_id = category OR tt.parent = category);
	
	SELECT p.id, p.post_title, p.post_content, p.post_date, p.post_date_gmt, p.post_name, pp.guid as feature_image, 
			m1.meta_value as metadata, cate_name, p.comment_count, cate_parent_name
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
					WHERE tt.term_id = category OR tt.parent = category)
	ORDER BY p.post_date DESC
	limit _start, _end;
	
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_posts_by_ids;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_ids`(
	IDs TEXT
)
BEGIN
	SELECT p.id, p.post_title, p.post_content, p.post_date, p.post_date_gmt, p.post_name, pp.guid as feature_image, m1.meta_value as metadata  , p.comment_count
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND FIND_IN_SET(p.ID, ids)
    order by FIND_IN_SET(p.ID, ids) desc;

END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_posts_by_slug;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_slug`(
	_categorySlug varchar(200),
    _start INT,
    _end INT
)
BEGIN
	DECLARE count  INT;
	DECLARE _category INT;
	DECLARE cate_name VARCHAR(200);
    SELECT t.term_id, t.name INTO _category, cate_name FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" WHERE slug = _categorySlug;
   
	SELECT p.id, p.post_title, p.post_content, p.post_date, p.post_date_gmt, p.post_name, pp.guid as feature_image, m1.meta_value as metadata, cate_name, p.comment_count
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
					WHERE tt.term_id = _category OR tt.parent = _category)
	ORDER BY p.post_date DESC
	limit _start, _end;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS get_posts_by_tag;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_posts_by_tag`(
	_tag varchar(200),
    _start INT,
    _end INT,
    OUT TotalItems INT 
    )
BEGIN
	SELECT count(*)
    INTO TotalItems
	FROM wp_terms t
	INNER JOIN wp_term_taxonomy tt ON tt.term_id = t.term_id AND taxonomy = 'post_tag'
	INNER JOIN wp_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
	INNER JOIN wp_posts p ON p.ID = tr.object_id AND p.post_type='post' AND p.post_status='publish'
    WHERE t.slug =  _tag;
    
	SELECT p.ID, p.post_title, p.post_content, p.post_date, p.post_name, t.name as tags, pp.guid as feature_image, pm.meta_value as metadata, p.comment_count
	FROM wp_terms t
	INNER JOIN wp_term_taxonomy tt ON tt.term_id = t.term_id AND taxonomy = 'post_tag'
	INNER JOIN wp_term_relationships tr ON tr.term_taxonomy_id = tt.term_taxonomy_id
	INNER JOIN wp_posts p ON p.ID = tr.object_id AND p.post_type='post' AND p.post_status='publish'
    LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
    LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value and pp.post_type = "attachment"
    LEFT JOIN wp_postmeta as pm ON pm.post_id = m.meta_value AND pm.meta_key = "_wp_attachment_metadata"
	WHERE t.slug =  _tag
	ORDER BY p.post_date DESC
    LIMIT _start,_end;
    /*DROP TEMPORARY TABLE IF EXISTS list_tags;*/
    

END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_recent_posts;

DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `get_recent_posts`(
	start INT,
    end INT,
    OUT TotalItems INT
)
BEGIN
	DECLARE category INT;
    SELECT t.term_id INTO category FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" WHERE slug = 'video';
    SELECT count(*)
    INTO TotalItems
    FROM wp_posts as p
	WHERE p.post_type = 'post' AND p.post_status = 'publish' 
    AND ID NOT IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
                    WHERE tt.term_id = category OR tt.parent = category);
    
	SELECT p.id as ID, p.post_title as PostTitle, p.post_content as PostContent, p.post_date as PostDate, p.post_date_gmt as PostDateGMT, 
    p.post_name as Slug, pp.guid as FeatureImage, m1.meta_value as Metadata, p.comment_count as CommentCount
    FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish' 
    AND p.ID NOT IN (SELECT tr.object_id from wp_term_relationships as tr 
					INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
                    WHERE tt.term_id = category OR tt.parent = category)
    ORDER BY p.post_date DESC
	limit start, end;
    
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_rss;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_rss`()
get_rss:BEGIN
    SELECT p.post_name As Slug
          ,p.post_title AS PostTitle
          ,p.post_date_gmt AS PostDateGMT
          ,p.post_content AS PostContent
          ,pp.guid as FeatureImage
          ,m1.meta_value as Metadata
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment" 
	WHERE p.post_type = 'post' AND p.post_status = 'publish'
    ORDER BY p.post_date_gmt DESC
    LIMIT 50;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_sitemap;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_sitemap`()
get_sitemap:BEGIN

    SELECT p.ID
          ,p.post_name As Slug
          ,p.post_type AS PostType
          ,p.post_modified_gmt AS ModifiedDate
	FROM wp_posts p 
	WHERE p.post_type IN ('post', 'page') AND post_name <> ''
    AND p.post_status = 'publish'
    AND p.post_modified_gmt > '2020-12-31'

    

    UNION

    SELECT  t.term_id
           ,t.slug As Slug
           ,wtt.taxonomy
           ,NULL
    FROM wp_terms t 
    INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" 
    WHERE wtt.count > 0
    
    ORDER BY PostType DESC
    ,ModifiedDate DESC;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS get_sitemap_news;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_sitemap_news`()
get_sitemap_news:BEGIN
    SELECT p.post_name As Slug
          ,p.post_title AS Title
          ,p.post_modified_gmt AS ModifiedDate
          ,GROUP_CONCAT(t.name separator ', ') AS Tags
	FROM wp_posts p 
    INNER JOIN wp_term_relationships as t_r ON t_r.object_id = p.ID
	INNER JOIN wp_term_taxonomy as t_t ON t_r.term_taxonomy_id = t_t.term_taxonomy_id AND taxonomy = 'post_tag'
	INNER JOIN wp_terms as t ON t_t.term_id = t.term_id
	WHERE p.post_type ="post" and post_name <> '' 
		and p.post_modified_gmt >= DATE_SUB(NOW(), INTERVAL 2 DAY)
		and p.post_status = 'publish'
	GROUP BY p.post_name, p.post_type, p.post_title, p.post_modified_gmt
    ORDER BY p.post_modified_gmt DESC;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS get_top_posts_by_cate_slug;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_top_posts_by_cate_slug`(
	cateSlug varchar(200),
    start INT,
    end INT
)
BEGIN
	DECLARE category INT;
    DECLARE limitDate datetime;
    SELECT DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY) INTO limitDate;
    SELECT t.term_id INTO category FROM wp_terms t INNER JOIN wp_term_taxonomy wtt ON t.term_id = wtt.term_id AND taxonomy = "category" WHERE slug = cateSlug;
    
	SELECT p.id, p.post_title, p.post_content, p.post_date, p.post_date_gmt, p.post_name, pp.guid as feature_image, m1.meta_value as metadata, pm.meta_value as views, p.comment_count
	FROM wp_posts as p
	LEFT JOIN wp_postmeta as pm ON pm.post_id = p.ID AND pm.meta_key = "trx_addons_post_views_count"
	LEFT JOIN wp_postmeta as m ON m.post_id = p.ID and m.meta_key = "_thumbnail_id"
	LEFT JOIN wp_postmeta as m1 ON m1.post_id = m.meta_value AND m1.meta_key = "_wp_attachment_metadata"
	LEFT JOIN wp_posts as pp ON pp.ID = m.meta_value AND pp.post_type="attachment"
	WHERE p.post_type = "post" AND p.post_status = "publish" AND p.post_date >= limitDate
	AND p.ID IN (SELECT tr.object_id from wp_term_relationships as tr 
						INNER JOIN wp_term_taxonomy as tt ON tt.term_taxonomy_id = tr.term_taxonomy_id AND tt.taxonomy = "category"
						WHERE tt.term_id = category OR tt.parent = category)
	ORDER BY ABS(pm.meta_value) DESC
    LIMIT start,end;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS social_disconnect_type;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_disconnect_type`(
	IN userId INT, 
	IN loginType varchar(30),
    OUT NewLoginType varchar(30),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	

	DELETE FROM wp_social_users
    WHERE ID = UserId AND type = loginType;
    
    SELECT group_concat(s.type separator ',') INTO NewLoginType FROM wp_social_users s where ID = UserId;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS social_user_create;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_user_create`(
	IN FirstName NVARCHAR(200),
    IN LastName NVARCHAR(200),
    IN DisplayName NVARCHAR(200),
    IN Email VARCHAR(200),
    IN Identifier VARCHAR(200),
	IN LoginType VARCHAR(200),
    IN Photo VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100),
    OUT UserId INT
)
BEGIN

	DECLARE UserExists INT;
    DECLARE Now DATETIME;
    SET UserExists = 0;
    SET Now = LOCALTIME();
	SELECT ID 
	INTO UserExists
	FROM `wp_users`
	WHERE user_login = Email OR user_login = Identifier OR user_email = Email;
    
    IF (UserExists = 0) THEN
		INSERT INTO `wp_users`
		(`user_login`,
		`user_pass`,
		`user_nicename`,
		`user_email`,
		`user_registered`,
		`user_status`,
		`display_name`)
		VALUES
		(IFNULL(Email,Identifier),
		'',
		FirstName,
		Email,
		Now,
		0,
		DisplayName
		);
		
		SET UserId = LAST_INSERT_ID();
		
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'nickname',
		FirstName);
		
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'first_name',
		FirstName);
		
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'last_name',
		LastName);
		
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'wp_capabilities',
		'a:0:{}');
		
		INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'email_confirmed',
		IF(ISNULL(Email),0,1));
        
        INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'photo',
		Photo);
        
	ELSE
		DELETE FROM `wp_usermeta`
        WHERE user_id = UserExists AND meta_key = 'token_confirmed';
        
        UPDATE `wp_usermeta`
		SET meta_value = 1
		WHERE user_id = UserExists AND meta_key = 'email_confirmed' AND meta_value = 0;
        
        SET UserId = UserExists;
	END IF;
    
    INSERT INTO `wp_social_users`
	(`ID`,
	`type`,
	`identifier`,
    `register_date`,
    `login_date`,
    `link_date`)
	VALUES
	(UserId,
	LoginType,
    Identifier,
    Now,
    Now,
	Now);
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS social_user_get_login;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_user_get_login`(
	identifier VARCHAR(200),
    loginType VARCHAR(200)
)
BEGIN
	SELECT user.ID,
			user_email as Email,
			display_name as `Name`,
			user_pass as `Password`,
            m.meta_value as Photo,
			1 as EmailConfirmed,
            su.`type` as LoginType
		FROM wp_users as user
        INNER JOIN wp_social_users as su ON su.ID = user.ID AND su.`type` = loginType
		LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'photo'
		WHERE su.identifier = identifier 
			AND EXISTS (SELECT 1 FROM wp_usermeta as tmp 
				WHERE tmp.user_id =user.ID AND tmp.meta_key = 'wp_capabilities' AND tmp.meta_value = 'a:0:{}');
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_confirm_email;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_confirm_email`(
    IN id INT,
    IN token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
User_Confirm_Email:BEGIN

	DECLARE UserId INT;
    SET UserId = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'token_confirmed'
    INNER JOIN `wp_usermeta` AS mc ON u.ID = mc.user_id AND mc.meta_key = 'email_confirmed'
	WHERE u.ID = id AND m.meta_value = token AND mc.meta_value = 0;
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token does not exist';
        LEAVE User_Confirm_Email;
	END IF;
    
    UPDATE `wp_usermeta`
    SET meta_value = 1
    WHERE meta_key= 'email_confirmed' AND user_id = UserId;
    
    DELETE FROM `wp_usermeta`
    WHERE meta_key= 'token_confirmed' AND user_id = UserId;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_create;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create`(
	IN _name NVARCHAR(100),
    IN _email VARCHAR(100),
    IN _password VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100),
    OUT UserId INT
)
User_Create:BEGIN

	DECLARE UserExists INT;
    
	SELECT 1 
	INTO UserExists
	FROM `wp_users`
	WHERE user_login = _email OR user_email = _email;
    
    IF (UserExists = 1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email đã tồn tại';
        LEAVE User_Create;
	END IF;
    
	INSERT INTO `wp_users`
	(`user_login`,
	`user_pass`,
	`user_nicename`,
	`user_email`,
	`user_registered`,
	`user_status`,
	`display_name`)
	VALUES
	(_email,
	_password,
	_name,
	_email,
	LOCALTIME(),
	0,
	_name
	);
	
	SET UserId = LAST_INSERT_ID();
	
	INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'nickname',
	_name);
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'first_name',
	_name);
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'wp_capabilities',
	'a:0:{}');
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'email_confirmed',
	0);
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_create_token_confirm;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_token_confirm`(
	IN Email VARCHAR(200),
    IN Token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
User_Create_Token_Confirm:BEGIN

	DECLARE UserId INT;
    DECLARE UMetaId INT;
    SET UserId = -1;
    SET UMetaId = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'wp_capabilities'
	WHERE u.user_login = Email AND u.user_email = Email AND m.meta_value = 'a:0:{}';
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User does not exist';
        LEAVE User_Create_Token_Confirm;
	END IF;
    
    SELECT m.umeta_id
    INTO UMetaId
    FROM `wp_usermeta` AS m
    WHERE m.user_id = UserId AND m.meta_key = 'token_confirmed';
    
    IF (UMetaId = -1) THEN
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'token_confirmed',
		Token);
	ELSE
		UPDATE `wp_usermeta`
		SET meta_value = Token
		WHERE umeta_id = UMetaId;
	END IF;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_create_token_reset;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_token_reset`(
	IN Email VARCHAR(200),
    IN Token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
User_Create_Token_Reset:BEGIN

	DECLARE UserId INT;
    DECLARE UMetaId INT;
    DECLARE UConfirm INT;
    SET UserId = -1;
    SET UMetaId = -1;
    SET UConfirm = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'wp_capabilities'
	WHERE u.user_login = Email AND u.user_email = Email AND m.meta_value = 'a:0:{}';
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Email này chưa được đăng ký';
        LEAVE User_Create_Token_Reset;
	END IF;
    
    SELECT 1
	INTO UConfirm
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'email_confirmed'
	WHERE u.user_login = Email AND u.user_email = Email AND m.meta_value = 1;
    
    IF (UConfirm = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Vui lòng xác minh email trước';
        LEAVE User_Create_Token_Reset;
	END IF;
    
    SELECT m.umeta_id
    INTO UMetaId
    FROM `wp_usermeta` AS m
    WHERE m.user_id = UserId AND m.meta_key = 'token_reset';
    
    IF (UMetaId = -1) THEN
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserId,
		'token_reset',
		Token);
	ELSE
		UPDATE `wp_usermeta`
		SET meta_value = Token
		WHERE umeta_id = UMetaId;
	END IF;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_get_by_id;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_by_id`(
	IN UserId INT
)
BEGIN

	DECLARE LoginType nvarchar(200);
    
    SELECT group_concat(s.type separator ',') INTO LoginType FROM wp_social_users s where ID = UserId;
    
	SELECT user.ID,
		user_email as Email,
		display_name as `Name`,
        user_pass as `Password`,
        m2.meta_value as Phone,
        m3.meta_Value as Gender,
        m4.meta_value as Photo,
        CONVERT(IFNULL(m.meta_value, 0), SIGNED) as EmailConfirmed,
        user_registered as RegisterDate,
        m1.meta_value as SavedPosts,
        LoginType
    FROM wp_users as user
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    WHERE user.ID = UserId 
        AND EXISTS (SELECT 1 FROM wp_usermeta as tmp 
			WHERE tmp.user_id =user.ID AND tmp.meta_key = 'wp_capabilities' AND tmp.meta_value = 'a:0:{}');
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_get_login;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_login`(
	email VARCHAR(100)
)
BEGIN
	SELECT user.ID,
		user_email as Email,
		display_name as `Name`,
        user_pass as `Password`,
        m2.meta_value as Phone,
        m3.meta_Value as Gender,
        m4.meta_value as Photo,
        CONVERT(IFNULL(m.meta_value, 0), SIGNED) as EmailConfirmed,
        user_registered as RegisterDate,
        m1.meta_value as SavedPosts
    FROM wp_users as user
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    WHERE user.user_login = email 
		AND user.user_email = email
        AND m.meta_value =  1
        AND EXISTS (SELECT 1 FROM wp_usermeta as tmp 
			WHERE tmp.user_id =user.ID AND tmp.meta_key = 'wp_capabilities' AND tmp.meta_value = 'a:0:{}');
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_reset_password;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_reset_password`(
    IN id INT,
    IN _password varchar(200),
    IN token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
User_Reset_Password:BEGIN

	DECLARE UserId INT;
    SET UserId = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'token_reset'
	WHERE u.ID = id AND m.meta_value = token;
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token does not exist';
        LEAVE User_Reset_Password;
	END IF;
    
    UPDATE `wp_users` as u
    SET u.user_pass = _password WHERE u.ID = id;
    
    DELETE FROM `wp_usermeta`
    WHERE meta_key= 'token_reset' AND user_id = UserId;
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_save_post;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_save_post`(
	IN UserID INT,
    IN ListPosts TEXT,
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
user_save_post:BEGIN

	DECLARE UserExists INT;
    DECLARE checkExist INT;
    
	SELECT 1 
	INTO UserExists
	FROM `wp_users`
	WHERE ID = UserID;
    
    IF (UserExists != 1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User does not exists';
        LEAVE user_save_post;
	END IF;

	
    SELECT count(*) INTO checkExist FROM wp_usermeta where user_id = UserID AND meta_key = 'saved_posts';
    if(checkExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = listPosts
        WHERE user_id = UserID ANd meta_key = 'saved_posts';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'saved_posts',
		ListPosts);
    END IF;
    
    SET ErrCode = 0,
		ErrMsg = 'Update data successfully';
    
END
//
DELIMITER ;



DROP PROCEDURE IF EXISTS user_update_info;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_update_info`(
	IN UserID INT,
    IN _name varchar(200),
    IN _password varchar(200),
    IN _phone varchar(200),
    IN _gender varchar(200),
    IN _photo varchar(200),
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
user_update_info:BEGIN

	DECLARE UserExists INT;
    DECLARE checkPhoneExist INT;
    DECLARE checkGenderExist INT;
    DECLARE checkPhotoExist INT;
    DECLARE checkName varchar(200);
    
	SELECT 1, display_name 
	INTO UserExists, checkName
	FROM `wp_users`
	WHERE ID = UserID;
    
    IF (UserExists != 1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User does not exists';
        LEAVE user_update_info;
	END IF;
    
    
    
    UPDATE `wp_users`
	SET
	`user_pass` = _password,
	`user_nicename` = _name,
	`display_name` = _name
	WHERE `ID` = UserID;
    
    IF(checkName != _name)
    THEN
		UPDATE `wp_comments`
		SET
		`comment_author` = _name
		WHERE `user_id` = UserID;
        
    END IF;
    
    SELECT count(*) INTO checkPhoneExist FROM wp_usermeta where user_id = UserID AND meta_key = 'phone';
    if(checkPhoneExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _phone
        WHERE user_id = UserID ANd meta_key = 'phone';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'phone',
		_phone);
    END IF;
    
    SELECT count(*) INTO checkGenderExist FROM wp_usermeta where user_id = UserID AND meta_key = 'gender';
    if(checkGenderExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _gender
        WHERE user_id = UserID ANd meta_key = 'gender';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'gender',
		_gender);
    END IF;
    
    SELECT count(*) INTO checkPhotoExist FROM wp_usermeta where user_id = UserID AND meta_key = 'photo';
    if(checkPhotoExist > 0)
    THEN
		UPDATE `wp_usermeta`
        SET meta_value = _photo
        WHERE user_id = UserID ANd meta_key = 'photo';
	ELSE 
		 INSERT INTO `wp_usermeta`
		(`user_id`,
		`meta_key`,
		`meta_value`)
		VALUES
		(UserID,
		'photo',
		_photo);
    END IF;
    
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_verify_token_reset;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_verify_token_reset`(
    IN id INT,
    IN token VARCHAR(200),
    OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
User_Verify_Token_Reset:BEGIN

	DECLARE UserId INT;
    SET UserId = -1;
    
	SELECT u.ID 
	INTO UserId
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'token_reset'
	WHERE u.ID = id AND m.meta_value = token;
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Token does not exist';
        LEAVE User_Verify_Token_Reset;
	END IF;
END
//
DELIMITER ;



