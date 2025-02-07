namespace SabaNews.Services;

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Fanex.Caching;
using SabaNews.Core.Constants;
using SabaNews.Core.Helper;
using SabaNews.Core.Services;
using SabaNews.Models.Posts;
using SabaNews.Services.Interfaces;

public class RefreshCachingService : IRefreshCachingService
{
    private readonly IFetchDataService fetchDataService;
    private readonly ICacheWrapperService cacheWrapperService;
    private readonly IPostService postService;
    private readonly IBannerService bannerService;
    private readonly ILogServiceProvider logService;

    public RefreshCachingService(IFetchDataService fetchDataService,
        ICacheWrapperService cacheWrapperService,
        IPostService postService,
        ILogServiceProvider logService,
        IBannerService bannerService)
    {
        this.fetchDataService = fetchDataService;
        this.cacheWrapperService = cacheWrapperService;
        this.postService = postService;
        this.logService = logService;
        this.bannerService = bannerService;
    }

    public async Task UpdateHomePageCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateHomePageCaching");
        try
        {
            var data = await fetchDataService.GetHomePageViewModel();
            logService.WriteLogFileInfo(string.Format("After GetHomePageViewModel - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.HomePageViewModel,
                    data,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheHomePageTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateHomePageCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateMenuCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateMenuCaching");

        try
        {
            var listMenu = new List<string>
            {
                MenuType.MainMenu,
                MenuType.DetailMenu
            };
            foreach(var menuType in listMenu)
            {
                var data = await fetchDataService.GetMenuData(menuType);
                logService.WriteLogFileInfo(string.Format("After GetMenuData - {0} - {1}", menuType, DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
                await cacheWrapperService.SetAsync(menuType,
                        data,
                        new CacheItemOptions
                        {
                            RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheMenuTimeoutMinutes)
                        });
            }
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }
        logService.WriteLogFileInfo(string.Format("Done UpdateMenuCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateCategoryCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateCategoryCaching");

        try
        {
            var listCategoryCaching = new List<string>
            {
                CategoryKey.NewPostSlug,
                CategoryKey.GuessSlug,
                CategoryKey.BackstageSlug,
                CategoryKey.TransferSlug,
                CategoryKey.OtherPostSlug,
                CategoryKey.VideoSlug,
                CategoryKey.VNFootballSlug
            };
            foreach (var slug in listCategoryCaching)
            {
                var key = CacheKey.CategoryViewModel + "-" + slug;
                var data = await fetchDataService.GetCategoryViewModel(slug);
                logService.WriteLogFileInfo(string.Format("After GetCategoryViewModel - {1} - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds, slug));
                await cacheWrapperService.SetAsync(key,
                    data,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheCategoryTimeoutMinutes)
                    });
            }
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateCategoryCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateNewsSitemapData()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateNewsSitemapData");

        try
        {
            var result = await postService.GetNewsSitemapDataAsync();
            logService.WriteLogFileInfo(string.Format("After GetNewsSitemapDataAsync - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.NewsSitemapXml,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheNewSitemapTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateNewsSitemapData - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateRSSData()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateRSSData");

        try
        {
            var result = await postService.GetNewsSitemapDataAsync();
            logService.WriteLogFileInfo(string.Format("After GetNewsSitemapDataAsync - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.RSS,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheRSSTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateRSSData - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateBannerCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateBannerCaching");

        try
        {
            var result = await bannerService.GetBannerInfoAsync();
            logService.WriteLogFileInfo(string.Format("After GetBannerInfoAsync - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.Banner,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheBannerTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateBannerCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateWorldCupCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start RefreshWorldCupCaching");

        try
        {
            var result = await fetchDataService.GetWorldCupViewModel();
            logService.WriteLogFileInfo(string.Format("After GetWorldCupViewModel - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.WorldCup,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheWorldCupTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done RefreshWorldCupCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateHomepageFixtureCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateHomepageFixtureCaching");

        try
        {
            var result = await fetchDataService.GetHomepageFixture();
            logService.WriteLogFileInfo(string.Format("After GetHomepageFixture - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.HomePageFixture,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheHompageFixtureTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateHomepageFixtureCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateHomepageStandingCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateHomepageStandingCaching");

        try
        {
            var result = await fetchDataService.GetHomepageStanding();
            logService.WriteLogFileInfo(string.Format("After GetHomepageStanding - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.HomePageStanding,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheHompageFixtureTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateHomepageStandingCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateCategoryPostCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateCategoryPostCaching");

        try
        {
            var listCategoryCaching = new List<string>
            {
                CategoryKey.VideoSlug,
                CategoryKey.GuessSlug
            };
            foreach (var slug in listCategoryCaching)
            {
                var key = CacheKey.CategoryPosts + "-" + slug;
                var result = await postService.GetPostsBySlugAsync(slug, Constants.FromFirstItem, Constants.GetTenItems);
                logService.WriteLogFileInfo(string.Format("After Get {0} - {1}", key, DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
                await cacheWrapperService.SetAsync(key,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheCategoryPostTimeoutMinutes)
                    });
            }
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateCategoryPostCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateRecentPostsCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateRecentPostCaching");

        try
        {
            var result = await postService.GetRecentPostsAsync(new GetRecentPostsParam { Start = Constants.FromFirstItem, End = Constants.GetElevenItems});
            logService.WriteLogFileInfo(string.Format("After GetRecentPostData - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.RecentPost,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheRecentPostTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateRecentPostCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }

    public async Task UpdateTodayMatchesCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateTodayMatchesCaching");

        try
        {
            var result = await fetchDataService.GetTodayMatches();
            logService.WriteLogFileInfo(string.Format("After GetTodayMatches - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.TodayMatches,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheTodayMatchesTimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateTodayMatchesCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }
    public async Task UpdateEuro2024HomepageCaching()
    {
        var startTime = DateTimeUtilize.UtcNow();
        logService.WriteLogFileInfo("Start UpdateEuro2024HomepageCaching");

        try
        {
            var result = await fetchDataService.GetEuro2024ViewModel();
            logService.WriteLogFileInfo(string.Format("After GetEuro2024ViewModel - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
            await cacheWrapperService.SetAsync(CacheKey.Euro2024,
                    result,
                    new CacheItemOptions
                    {
                        RelativeExpiration = TimeSpan.FromMinutes(Constants.CacheEuro2024TimeoutMinutes)
                    });
        }
        catch (Exception ex)
        {
            await logService.WriteExceptionSentryErrorAsync(ex);
            logService.WriteLogFileInfo(ex.ToString());
        }

        logService.WriteLogFileInfo(string.Format("Done UpdateEuro2024HomepageCaching - {0}", DateTimeUtilize.UtcNow().Subtract(startTime).Milliseconds));
    }
}