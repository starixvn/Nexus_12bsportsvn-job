namespace SabaNews.Services.Interfaces
{
    using System.Threading.Tasks;

    public interface IRefreshCachingService
    {
        Task UpdateHomePageCaching();

        Task UpdateMenuCaching();

        Task UpdateCategoryCaching();

        Task UpdateNewsSitemapData();

        Task UpdateRSSData();

        Task UpdateBannerCaching();

        Task UpdateWorldCupCaching();

        Task UpdateHomepageFixtureCaching();

        Task UpdateHomepageStandingCaching();

        Task UpdateCategoryPostCaching();

        Task UpdateRecentPostsCaching();

        Task UpdateTodayMatchesCaching();
        
        Task UpdateEuro2024HomepageCaching();
    }
}