DROP PROCEDURE IF EXISTS banner_get_info;

DELIMITER //
CREATE DEFINER=`sabasports`@`%` PROCEDURE `banner_get_info`()
BEGIN
	DECLARE DesktopTopNavigationUrl VARCHAR(500);
    DECLARE DesktopTopUrl VARCHAR(500);
    DECLARE MobileTopUrl VARCHAR(500);
    DECLARE MobileTopNavigationUrl VARCHAR(500);
    DECLARE DesktopCenterUrl VARCHAR(500);
    DECLARE DesktopCenterNavigationUrl VARCHAR(500);
    DECLARE MobileCenterUrl VARCHAR(500);
    DECLARE MobileCenterNavigationUrl VARCHAR(500); 
    DECLARE DesktopLeftUrl VARCHAR(500);
    DECLARE DesktopLeftNavigationUrl VARCHAR(500);
    DECLARE DesktopRightUrl VARCHAR(500);
    DECLARE DesktopRightNavigationUrl VARCHAR(500);
    DECLARE MobileBottomUrl VARCHAR(500);
    DECLARE MobileBottomNavigationUrl VARCHAR(500);
   
    
	SELECT wo.option_value INTO DesktopTopNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_navigation_url";
    
    SELECT wo.option_value INTO DesktopTopUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_url";
    
    SELECT wo.option_value INTO MobileTopUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_url";
    
    SELECT wo.option_value INTO MobileTopNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_navigation_url";
    
    SELECT wo.option_value INTO DesktopCenterUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_center_url";
    
    SELECT wo.option_value INTO DesktopCenterNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_center_navigation_url";
    
    SELECT wo.option_value INTO MobileCenterUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_center_url";
    
    SELECT wo.option_value INTO MobileCenterNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_center_navigation_url";
    
    SELECT wo.option_value INTO DesktopLeftUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_left_url";
    
    SELECT wo.option_value INTO DesktopLeftNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_left_navigation_url";
    
    SELECT wo.option_value INTO DesktopRightUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_right_url";
    
    SELECT wo.option_value INTO DesktopRightNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_desktop_right_navigation_url";
    
    SELECT wo.option_value INTO MobileBottomUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_bottom_url";
    
    SELECT wo.option_value INTO MobileBottomNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_mobile_bottom_navigation_url";
    
    SELECT DesktopTopNavigationUrl, DesktopTopUrl, MobileTopUrl, MobileTopNavigationUrl
			, DesktopCenterUrl, DesktopCenterNavigationUrl, MobileCenterUrl, MobileCenterNavigationUrl
            , DesktopLeftUrl, DesktopLeftNavigationUrl, DesktopRightUrl, DesktopRightNavigationUrl
            , MobileCenterUrl, MobileCenterNavigationUrl, MobileBottomUrl, MobileBottomNavigationUrl;
END

//
DELIMITER ;	

DROP PROCEDURE IF EXISTS banner_update;

DELIMITER //

CREATE DEFINER=`sabasports`@`%` PROCEDURE `banner_update`(
	IN DesktopTopNavigationUrl VARCHAR(500),
    IN DesktopTopUrl VARCHAR(500),
    IN MobileTopUrl VARCHAR(500),
    IN MobileTopNavigationUrl VARCHAR(500),
    IN DesktopCenterUrl VARCHAR(500),
	IN DesktopCenterNavigationUrl VARCHAR(500),
    IN DesktopLeftUrl VARCHAR(500),
	IN DesktopLeftNavigationUrl VARCHAR(500),
    IN DesktopRightUrl VARCHAR(500),
	IN DesktopRightNavigationUrl VARCHAR(500),
    IN MobileCenterUrl VARCHAR(500),
	IN MobileCenterNavigationUrl VARCHAR(500),
    IN MobileBottomUrl VARCHAR(500),
	IN MobileBottomNavigationUrl VARCHAR(500),
    IN ActorId INT,
	OUT ErrCode SMALLINT,
    OUT ErrMsg VARCHAR(100)
)
BEGIN
	DECLARE DesktopTopNavigationUrlExist VARCHAR(500);
    DECLARE DesktopTopUrlExist VARCHAR(500);
    DECLARE MobileTopUrlExist VARCHAR(500);
    DECLARE MobileTopNavigationUrlExist VARCHAR(500);
    DECLARE DesktopCenterUrlExist VARCHAR(500);
    DECLARE DesktopCenterNavigationUrlExist VARCHAR(500);
    DECLARE DesktopLeftUrlExist VARCHAR(500);
    DECLARE DesktopLeftNavigationUrlExist VARCHAR(500);
    DECLARE DesktopRightUrlExist VARCHAR(500);
    DECLARE DesktopRightNavigationUrlExist VARCHAR(500);
    DECLARE MobileCenterUrlExist VARCHAR(500);
    DECLARE MobileCenterNavigationUrlExist VARCHAR(500);
    DECLARE MobileBottomUrlExist VARCHAR(500);
    DECLARE MobileBottomNavigationUrlExist VARCHAR(500);
    DECLARE LogData LONGTEXT;

    
    SELECT option_value INTO DesktopTopNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_navigation_url';
    SELECT option_value INTO DesktopTopUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_url';
    SELECT option_value INTO MobileTopUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_url';
    SELECT option_value INTO MobileTopNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_navigation_url';
    SELECT option_value INTO DesktopCenterUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_center_url';
    SELECT option_value INTO DesktopCenterNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_center_navigation_url';
    SELECT option_value INTO DesktopLeftUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_left_url';
    SELECT option_value INTO DesktopLeftNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_left_navigation_url';
    SELECT option_value INTO DesktopRightUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_right_url';
    SELECT option_value INTO DesktopRightNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_desktop_right_navigation_url';
    SELECT option_value INTO MobileCenterUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_center_url';
    SELECT option_value INTO MobileCenterNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_center_navigation_url';
    SELECT option_value INTO MobileBottomUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_bottom_url';
    SELECT option_value INTO MobileBottomNavigationUrlExist FROM wp_options WHERE  option_name = 'banner_mobile_bottom_navigation_url';
    
	IF(DesktopTopNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopTopNavigationUrl
        WHERE option_name = 'banner_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_navigation_url',
		IFNULL(DesktopTopNavigationUrl, ''));
    END IF;
    
    IF(DesktopTopUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopTopUrl
        WHERE option_name = 'banner_desktop_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_url',
		IFNULL(DesktopTopUrl, ''));
    END IF;
    
    IF(MobileTopUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileTopUrl
        WHERE option_name = 'banner_mobile_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_url',
		IFNULL(MobileTopUrl, ''));
    END IF;
    
    IF(MobileTopNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileTopNavigationUrl
        WHERE option_name = 'banner_mobile_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_navigation_url',
		IFNULL(MobileTopNavigationUrl, ''));
    END IF;
    
    IF(DesktopCenterUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopCenterUrl
        WHERE option_name = 'banner_desktop_center_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_center_url',
		IFNULL(DesktopCenterUrl, ''));
    END IF;
    
    IF(DesktopCenterNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopCenterNavigationUrl
        WHERE option_name = 'banner_desktop_center_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_center_navigation_url',
		IFNULL(DesktopCenterNavigationUrl, ''));
    END IF;
    
    IF(DesktopLeftUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopLeftUrl
        WHERE option_name = 'banner_desktop_left_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_left_url',
		IFNULL(DesktopLeftUrl, ''));
    END IF;
    
    IF(DesktopLeftNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopLeftNavigationUrl
        WHERE option_name = 'banner_desktop_left_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_left_navigation_url',
		IFNULL(DesktopLeftNavigationUrl, ''));
    END IF;
    
     IF(DesktopRightUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopRightUrl
        WHERE option_name = 'banner_desktop_right_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_right_url',
		IFNULL(DesktopRightUrl, ''));
    END IF;
    
    IF(DesktopRightNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = DesktopRightNavigationUrl
        WHERE option_name = 'banner_desktop_right_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_desktop_right_navigation_url',
		IFNULL(DesktopRightNavigationUrl, ''));
    END IF;
    
	IF(MobileCenterUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileCenterUrl
        WHERE option_name = 'banner_mobile_center_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_center_url',
		IFNULL(MobileCenterUrl, ''));
    END IF;
    
    IF(MobileCenterNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileCenterNavigationUrl
        WHERE option_name = 'banner_mobile_center_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_center_navigation_url',
		IFNULL(MobileCenterNavigationUrl, ''));
    END IF;
    
    IF(MobileBottomUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileBottomUrl
        WHERE option_name = 'banner_mobile_bottom_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_bottom_url',
		IFNULL(MobileBottomUrl, ''));
    END IF;
    
    IF(MobileBottomNavigationUrlExist IS NOT NULL)
    THEN
		UPDATE `wp_options`
        SET option_value = MobileBottomNavigationUrl
        WHERE option_name = 'banner_mobile_bottom_navigation_url';
	ELSE 
		 INSERT INTO `wp_options`
		(`option_name`,
		`option_value`)
		VALUES
		('banner_mobile_bottom_navigation_url',
		IFNULL(MobileBottomNavigationUrl, ''));
    END IF;
	
    SET LogData = CONCAT('{"DesktopTopNavigationUrl":"', IFNULL(DesktopTopNavigationUrl, ''), '","DesktopTopUrl":"', IFNULL(DesktopTopUrl, '') 
    ,'","MobileTopUrl":"', IFNULL(MobileTopUrl, ''), '","MobileTopNavigationUrl":"', IFNULL(MobileTopNavigationUrl, '') 
    ,'","DesktopCenterUrl":"', IFNULL(DesktopCenterUrl, ''), '","DesktopCenterNavigationUrl":"', IFNULL(DesktopCenterNavigationUrl, '')
    ,'","MobileCenterUrl":"', IFNULL(MobileCenterUrl, ''), '","MobileCenterNavigationUrl":"', IFNULL(MobileCenterNavigationUrl, '')
    ,'","DesktopLeftUrl":"', IFNULL(DesktopLeftUrl, ''), '","DesktopLeftNavigationUrl":"', IFNULL(DesktopLeftNavigationUrl, '')
    ,'","DesktopRightUrl":"', IFNULL(DesktopRightUrl	, ''), '","DesktopRightNavigationUrl":"', IFNULL(DesktopRightNavigationUrl, '')
    ,'","MobileBottomUrl":"', IFNULL(MobileBottomUrl	, ''), '","MobileBottomNavigationUrl":"', IFNULL(MobileBottomNavigationUrl, '')
    ,'"}');
    
    
    
    INSERT INTO `wp_Log`
	(`ActorId`,
	`ActionId`,
	`Data`,
    `LogDate`
    )
	VALUES
	(ActorId,
     1,
     LogData,
     LOCALTIME()
     );
END
//
DELIMITER ;	