namespace SabaNews.Models.Banner
{
    using SabaNews.Core.Constants;

    public class BannerModel
    {
        public string DesktopTopUrl { get; set; }
        public string DesktopTopUrlKey { get; set; } = BannerKey.DesktopTop;
        public string DesktopTopNavigationUrl { get; set; }
        public string DesktopTopNavigationUrlKey { get; set; } = BannerKey.DesktopTopNavigation;
        public string MobileTopUrl { get; set; }
        public string MobileTopUrlKey { get; set; } = BannerKey.MobileTop;
        public string MobileTopNavigationUrl { get; set; }
        public string MobileTopNavigationUrlKey { get; set; } = BannerKey.MobileTopNavigation;
        public string DesktopCenterUrl { get; set; }
        public string DesktopCenterUrlKey { get; set; } = BannerKey.DesktopCenter;
        public string DesktopCenterNavigationUrl { get; set; }
        public string DesktopCenterNavigationUrlKey { get; set; } = BannerKey.DesktopCenterNavigation;
        public string DesktopLeftUrl { get; set; }
        public string DesktopLeftUrlKey { get; set; } = BannerKey.DesktopLeft;
        public string DesktopLeftNavigationUrl { get; set; }
        public string DesktopLeftNavigationUrlKey { get; set; } = BannerKey.DesktopLeftNavigation;
        public string DesktopRightUrl { get; set; }
        public string DesktopRightUrlKey { get; set; } = BannerKey.DesktopRight;
        public string DesktopRightNavigationUrl { get; set; }
        public string DesktopRightNavigationUrlKey { get; set; } = BannerKey.DesktopRightNavigation;
        public string MobileCenterUrl { get; set; }
        public string MobileCenterUrlKey { get; set; } =  BannerKey.MobileCenter;
        public string MobileCenterNavigationUrl { get; set; }
        public string MobileCenterNavigationUrlKey { get; set; } =  BannerKey.MobileCenterNavigation;
        public string MobileBottomUrl { get; set; }
        public string MobileBottomUrlKey { get; set; } = BannerKey.MobileBottom;
        public string MobileBottomNavigationUrl { get; set; }
        public string MobileBottomNavigationUrlKey { get; set; } = BannerKey.MobileBottomNavigation;
        public string PostMobileTopUrl { get; set; }
        public string PostMobileTopUrlKey { get; set; } = BannerKey.PostMobileTopUrl;
        public string PostMobileTopNavigationUrl { get; set; }
        public string PostMobileTopNavigationUrlKey { get; set; } = BannerKey.PostMobileTopNavigation;
    }
}
