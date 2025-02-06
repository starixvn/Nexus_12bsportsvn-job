/*<info serverAlias="SSMS-sabasports" databaseType="2" executers="sabasports" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS banner_get_info;

DELIMITER //


CREATE DEFINER=`sabasports`@`%` PROCEDURE `banner_get_info`(
	/*
		Creator: Hank@20220316
        Revisions: - 20220316@Hank: init
					- 20230320@Hank: add banner interscroller
    */
)
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
    DECLARE PostMobileTopUrl VARCHAR(500);
    DECLARE PostMobileTopNavigationUrl VARCHAR(500);
   
    
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
    
    SELECT wo.option_value INTO PostMobileTopUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_post_mobile_top_url";
    
    SELECT wo.option_value INTO PostMobileTopNavigationUrl
    FROM wp_options wo 
    WHERE wo.option_name = "banner_post_mobile_top_navigation_url";
    
    SELECT DesktopTopNavigationUrl, DesktopTopUrl, MobileTopUrl, MobileTopNavigationUrl
			, DesktopCenterUrl, DesktopCenterNavigationUrl, MobileCenterUrl, MobileCenterNavigationUrl
            , DesktopLeftUrl, DesktopLeftNavigationUrl, DesktopRightUrl, DesktopRightNavigationUrl
            , MobileCenterUrl, MobileCenterNavigationUrl, MobileBottomUrl, MobileBottomNavigationUrl
            , PostMobileTopUrl, PostMobileTopNavigationUrl;
END

//
DELIMITER ;	