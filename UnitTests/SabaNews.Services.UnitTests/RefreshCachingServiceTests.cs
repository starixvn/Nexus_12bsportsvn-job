namespace SabaNews.Services.UnitTests
{
    using AutoFixture;
    using Fanex.Caching;
    using NSubstitute;
    using SabaNews.Core.Constants;
    using SabaNews.Core.Services;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Models;
    using SabaNews.Models.Banner;
    using SabaNews.Models.Home;
    using SabaNews.Models.Posts;
    using SabaNews.Models.ViewModel.Event.Euro2024;
    using SabaNews.Models.ViewModel.Event.WorldCup;
    using SabaNews.Models.ViewModel.Posts;
    using SabaNews.Services.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Xunit;

    public class RefreshCachingServiceTests
    {
        private IFetchDataService fetchDataService;
        private ICacheWrapperService cacheWrapperService;
        private IPostService postService;
        private ILogServiceProvider logService;
        private IBannerService bannerService;
        private IFixture fixture = new Fixture();

        [Fact]
        public async Task UpdateHomePageCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<PostViewModel>();

            fetchDataService.GetHomePageViewModel().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));
            

            //Act
            await service.UpdateHomePageCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateHomePageCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetHomePageViewModel()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateHomePageCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateMenuCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IEnumerable<Menu>>();

            fetchDataService.GetMenuData(Arg.Do<string>(x => x = MenuType.MainMenu)).Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateMenuCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateMenuCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetMenuData(Arg.Do<string>(x => x = MenuType.MainMenu))).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateMenuCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateCategoryCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var slug = fixture.Create<string>();
            var data = fixture.Create<BlogViewModel>();

            fetchDataService.GetCategoryViewModel(Arg.Do<string>(x => slug = x)).Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateCategoryCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateCategoryCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var slug = fixture.Create<string>();
            var page = fixture.Create<int>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetCategoryViewModel(Arg.Do<string>(x => slug = x))).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateCategoryCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }


        [Fact]
        public async Task UpdateNewsSitemapData_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IEnumerable<NewsSitemapModel>>();

            postService.GetNewsSitemapDataAsync().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateNewsSitemapData();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateNewsSitemapData_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            postService.When(x => x.GetNewsSitemapDataAsync()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateNewsSitemapData();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateRSSData_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IEnumerable<NewsSitemapModel>>();

            postService.GetNewsSitemapDataAsync().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateRSSData();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateRSSData_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            postService.When(x => x.GetNewsSitemapDataAsync()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateRSSData();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateBannerCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<BannerModel>();

            bannerService.GetBannerInfoAsync().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateBannerCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateBannerCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            bannerService.When(x => x.GetBannerInfoAsync()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateBannerCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateWorldCupCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<WorldCupViewModel>();

            fetchDataService.GetWorldCupViewModel().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateWorldCupCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateWorldCupCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetWorldCupViewModel()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateWorldCupCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateHomepageFixtureCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<List<MatchLeagueModel>>();

            fetchDataService.GetHomepageFixture().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateHomepageFixtureCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateHomepageFixtureCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetHomepageFixture()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateHomepageFixtureCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateHomepageStandingCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<List<StandingLeagueModel>>();

            fetchDataService.GetHomepageStanding().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateHomepageStandingCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateHomepageStandingCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetHomepageStanding()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateHomepageStandingCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateCategoryPostCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IEnumerable<Post>>();
            var slug = "slug";
            var start = 0;
            var end = 10;

            postService.GetPostsBySlugAsync(Arg.Do<string>(x => slug = x), Arg.Do<int>(x => start = x) , Arg.Do<int>(x => end = x)).Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateCategoryPostCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateCategoryPostCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();
            var slug = "slug";
            var start = 0;
            var end = 10;

            postService.When(x => x.GetPostsBySlugAsync(Arg.Do<string>(x => slug = x), Arg.Do<int>(x => start = x) , Arg.Do<int>(x => end = x))).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateCategoryPostCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateRecentPostsCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IEnumerable<Post>>();
            var param = fixture.Create<GetRecentPostsParam>();

            postService.GetRecentPostsAsync(Arg.Do<GetRecentPostsParam>(x => param = x)).Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateRecentPostsCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateRecentPostsCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();
            var param = fixture.Create<GetRecentPostsParam>();

            postService.When(x => x.GetRecentPostsAsync(Arg.Do<GetRecentPostsParam>(x => param = x))).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateRecentPostsCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateTodayMatchesCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<IList<Match>>();
            var param = fixture.Create<GetRecentPostsParam>();

            fetchDataService.GetTodayMatches().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateTodayMatchesCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        [Fact]
        public async Task UpdateTodayMatchesCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetTodayMatches()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateTodayMatchesCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateEuro2024HomepageCaching_WhenCalled_ThrowException()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var exception = fixture.Create<Exception>();

            fetchDataService.When(x => x.GetEuro2024ViewModel()).Throw(exception);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateEuro2024HomepageCaching();

            //Assert
            await logService.Received().WriteExceptionSentryErrorAsync(exception);
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
        }

        [Fact]
        public async Task UpdateEuro2024HomepageCaching_WhenCalled_CallExpectedFunction()
        {
            //Arrange
            var service = GetRefreshCachingService();
            var logMessage = fixture.Create<string>();
            var data = fixture.Create<Euro2024ViewModel>();

            fetchDataService.GetEuro2024ViewModel().Returns(data);
            logService.WriteLogFileInfo(Arg.Do<string>(x => logMessage = x));


            //Act
            await service.UpdateEuro2024HomepageCaching();

            //Assert
            logService.Received().WriteLogFileInfo(Arg.Any<string>());
            await cacheWrapperService.Received().SetAsync(Arg.Any<string>(), data, Arg.Any<CacheItemOptions>());
        }

        
        


        #region Helpers
        private RefreshCachingService GetRefreshCachingService()
        {
            fetchDataService = Substitute.For<IFetchDataService>();
            cacheWrapperService = Substitute.For<ICacheWrapperService>();
            postService = Substitute.For<IPostService>();
            logService = Substitute.For<ILogServiceProvider>();
            bannerService = Substitute.For<IBannerService>();
            var service = new RefreshCachingService(fetchDataService, cacheWrapperService, postService, logService, bannerService);

            return service;
        }
        #endregion Helpers
    }
}
