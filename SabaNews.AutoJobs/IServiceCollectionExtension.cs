namespace SabaNews.AutoJobs;

using System.Collections.Generic;
using Fanex.Caching;
using Fanex.Caching.Redis;
using Fanex.Data.Repository;
using Fanex.Logging;
using Fanex.Logging.Extensions;
using Fanex.Logging.Extensions.AspNetCore;
using Fanex.Logging.Extensions.Database;
using Fanex.Logging.Sentry;
using Livescore.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SabaNews.AutoJobs.Models;
using SabaNews.AutoJobs.Workers;
using SabaNews.Core.Repositories;
using SabaNews.Core.Services;
using SabaNews.Livescore.Repositories;
using SabaNews.Livescore.Services;
using SabaNews.Services;
using SabaNews.Services.Interfaces;

public static class IServiceCollectionExtension
{
    public static void AddConfiguration(this IServiceCollection services, IConfiguration configuration)
    {
        LogManager
        .SetDefaultLogCategory(configuration.GetSection("LogCategory").Value)
        .Use(new List<ILogEngine>
        {
            new SentryLogging(new SentryEngineOptions
            {
                Dsn = configuration.GetSection("SentryEngineOptions:Dsn").Value
            })
        });

        ExceptionHandler
            .UseConfig(new LoggingConfiguration())
            .UseGetDbExceptionInfo(DatabaseInfoGetters.GetDbExceptionInfo);

        services.AddSingleton(configuration);
        services.Configure<List<JobSettings>>(configuration.GetSection("JobSettings"));

        services.AddRedisCache(configuration.GetSection("RedisConfig"));
    }

    public static void AddDependencyInjection(this IServiceCollection services)
    {
        services.AddSingleton<IBaseService, BaseService>();
        services.AddSingleton<IDynamicRepository, DynamicRepository>();
        services.AddSingleton<IBaseRepository, BaseRepository>();
        services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
        services.AddSingleton<ICacheService, CacheService>();
        services.AddSingleton<ICacheWrapperService, CacheWrapperService>();
        services.AddSingleton<ILogger, Logger>();
        services.AddSingleton<ILogServiceProvider, LogServiceProvider>();
        
        services.AddTransient<ISerializerService, SerializerService>();
        services.AddTransient<IPostService, PostService>();
        services.AddTransient<IMatchService, MatchService>();
        services.AddTransient<ILeagueService, LeagueService>();
        services.AddTransient<IMatchRepository, MatchRepository>();
        services.AddTransient<IBannerService, BannerService>();
        services.AddTransient<IFetchDataService, FetchDataService>();
        services.AddTransient<IRefreshCachingService, RefreshCachingService>();
        services.AddTransient<IOptionService, OptionService>();
    }

    public static void AddWorker(this IServiceCollection services)
    {
        services.AddHostedService<RefreshHomePageCachingWorker>();
        services.AddHostedService<RefreshCategoryCachingWorker>();
        services.AddHostedService<RefreshMenuCachingWorker>();
        services.AddHostedService<RefreshNewsSitemapXmlFileWorker>();
        services.AddHostedService<RefreshRssWorker>();
        services.AddHostedService<RefreshBannerWorker>();
        services.AddHostedService<RefreshWorldCupCachingWorker>();
        services.AddHostedService<RefreshHomepageFixtureWorker>();
        services.AddHostedService<RefreshHomepageStandingWorker>();
        services.AddHostedService<RefreshCategoryPostsCachingWorker>();
        services.AddHostedService<RefreshRecentPostsCachingWorker>();
        services.AddHostedService<RefreshTodayMatchesCachingWorker>();
        services.AddHostedService<RefreshEuro2024HomepageCachingWorker>();
    }
}