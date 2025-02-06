DROP PROCEDURE IF EXISTS get_post_detail_by_slug_xtest;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `get_post_detail_by_slug_xtest`(Slug varchar(200), PostType varchar (30))
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
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_get_login_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_login_xtest`(
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
        m1.meta_value as SavedPosts,
        um.meta_value as Metadata
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    WHERE user.user_login = email 
		AND user.user_email = email;
     
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_get_by_id_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_get_by_id_xtest`(
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
        LoginType,
        um.meta_value as Metadata
    FROM wp_users as user
    LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
    LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'email_confirmed'
    LEFT JOIN wp_usermeta as m1 ON m1.user_id = user.ID and m1.meta_key = 'saved_posts'
    LEFT JOIN wp_usermeta as m2 ON m2.user_id = user.ID and m2.meta_key = 'phone'
    LEFT JOIN wp_usermeta as m3 ON m3.user_id = user.ID and m3.meta_key = 'gender'
    LEFT JOIN wp_usermeta as m4 ON m4.user_id = user.ID and m4.meta_key = 'photo'
    WHERE user.ID = UserId;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS social_user_get_login_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_user_get_login_xtest`(
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
            su.`type` as LoginType,
            m.meta_value as Metadata
		FROM wp_users as user
        INNER JOIN wp_social_users as su ON su.ID = user.ID AND su.`type` = loginType
		LEFT JOIN wp_usermeta as m ON m.user_id = user.ID and m.meta_key = 'photo'
        LEFT JOIN wp_usermeta as um ON um.user_id = user.ID AND um.meta_key = 'wp_capabilities'
		WHERE su.identifier = identifier;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS user_create_token_reset_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_token_reset_xtest`(
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
	WHERE u.user_login = Email AND u.user_email = Email;
    
    IF (UserId = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'User does not exist';
        LEAVE User_Create_Token_Reset;
	END IF;
    
	SELECT 1
	INTO UConfirm
	FROM `wp_users` AS u
    INNER JOIN `wp_usermeta` AS m ON u.ID = m.user_id AND m.meta_key = 'email_confirmed'
	WHERE u.user_login = Email AND u.user_email = Email AND m.meta_value = 1;
    
    IF (UConfirm = -1) THEN
		SET ErrCode = 1,
			ErrMsg = 'Please confirm email first';
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

DROP PROCEDURE IF EXISTS user_create_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `user_create_xtest`(
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
    
    INSERT INTO `wp_usermeta`
	(`user_id`,
	`meta_key`,
	`meta_value`)
	VALUES
	(UserId,
	'is_subscribe',
	1);
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS social_user_create_xtest;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `social_user_create_xtest`(
	IN FirstName NVARCHAR(200),
    IN LastName NVARCHAR(200),
    IN DisplayName NVARCHAR(200),
    IN Email VARCHAR(200),
    IN Identifier VARCHAR(200),
	IN LoginType VARCHAR(200),
    IN Photo LONGTEXT,
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
		'is_subscribe',
		1);
        
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

