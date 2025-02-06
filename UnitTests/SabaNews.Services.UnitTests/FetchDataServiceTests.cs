namespace SabaNews.Services.UnitTests
{
    using AutoFixture;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using NSubstitute;
    using SabaNews.Core.Constants;
    using SabaNews.Core.Constants.Livescore;
    using SabaNews.Core.Helper;
    using SabaNews.Criteria.Posts;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Services.Criteria.League;
    using SabaNews.Livescore.Services.Criteria.Match;
    using SabaNews.Models;
    using SabaNews.Models.Categories;
    using SabaNews.Models.Home;
    using SabaNews.Models.Options;
    using SabaNews.Models.Posts;
    using SabaNews.Models.ViewModel.Posts;
    using SabaNews.Services.Interfaces;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Livescore.Services.Interfaces;
    using Xunit;

    public class FetchDataServiceTests
    {
        private IPostService postService;
        private IConfiguration configuration;
        private IMatchService matchService;
        private ILeagueService leagueService;
        private IOptionService optionService;
        private readonly IFixture fixture = new Fixture();

        private readonly Option option = new()
        {
            OptionId = 0,
            OptionName = "football_news_categories",
            OptionValue = "[{\"Category\":\"World Cup\",\"Id\":1,\"Slug\":\"world-cup\",\"Url\":\"/tin-the-thao/bong-da/quoc-te/world-cup\",\"CreatedDate\":\"2023-01-31T07:16:31.8439748Z\"},{\"Category\":\"La Liga\",\"Id\":2,\"Slug\":\"la-liga\",\"Url\":\"/tin-the-thao/bong-da/tay-ban-nha/la-liga\",\"CreatedDate\":\"2023-01-31T06:45:02.7067665Z\"},{\"Category\":\"Tây Ban Nha\",\"Id\":3,\"Slug\":\"tay-ban-nha\",\"Url\":\"/tin-the-thao/bong-da/tay-ban-nha\",\"CreatedDate\":\"2023-01-31T07:32:57.3471868Z\"}]"
        };

        [Fact]
        public void GetHomePageViewModel_WhenCalled_ReturnExpectedPostViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = fixture.Create<string>();
            var first = fixture.Create<int>();
            var end = fixture.Create<int>();
            
            var paramGetRecent = fixture.Create<GetRecentPostsParam>();
            var newPosts = fixture.Create<IEnumerable<Post>>();
            var posts = fixture.Create<IEnumerable<Post>>();
            var category = fixture.Create<Category>(); 
            postService.GetRecentPostsAsync(Arg.Do<GetRecentPostsParam>(x => paramGetRecent = x)).Returns(newPosts);
            postService.GetPostsBySlugAsync(Arg.Do<string>(x => slug = x), Arg.Do<int>(x => first = x), Arg.Do<int>(x => end = x)).Returns(posts);
            postService.GetPageDetailBySlugAsync(Arg.Do<string>(x => slug = x)).Returns(category);
            
            //Act
            // var actual = await service.GetHomePageViewModel();

            //Assert
            // Assert.Equal(newPosts.ToArray(), actual.NewPosts);
            // Assert.Equal(posts.ToArray(), actual.FootballPosts);
            // Assert.Equal(posts.ToArray(), actual.OtherPosts);
            // Assert.Equal(posts.ToArray(), actual.TennisPosts);
            // Assert.Equal(posts.ToArray(), actual.VideoPosts);
            // Assert.Equal(posts.ToArray(), actual.GuessPosts);
            // Assert.Equal(posts.ToArray(), actual.BackstagePosts);
            // Assert.Equal(posts.ToArray(), actual.TransferPosts);
            // Assert.Equal(category, actual.Category);
        }

        [Fact]
        public async Task GetCategoryViewModel_WhenCallVideoCategory_ReturnExpectedCategoryViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = Constants.VideoSlug;
            var page = fixture.Create<int>();
            var criteria = fixture.Create<GetVideoPostsBySlugCriteria>();

            var newPosts = fixture.Create<IEnumerable<Post>>();
            var posts = fixture.Create<IEnumerable<Post>>();
            var category = fixture.Create<Category>();
            var expectedCateInfos = new List<CategoryGeneral>()
            {
                new() { Id = 1, Slug = "tin-the-thao" },
                new() { Id = 2, Slug = "video" }
            };
            postService.GetVideoPostsBySlugAsync(Arg.Do<GetVideoPostsBySlugCriteria>(x => criteria = x)).Returns(posts);
            postService.GetCateDetailAsync(Arg.Do<string>(x => slug = x)).Returns(category);
            postService.GetCateParentsAsync(Arg.Do<string>(x => x = slug)).Returns(expectedCateInfos);
            //Act
            var actual = await service.GetCategoryViewModel(slug);

            //Assert
            Assert.Equal(posts.ToArray(), actual.Posts);
            Assert.Equal(category, actual.Category);
            Assert.True(actual.IsVideo);
        }

        [Fact]
        public async Task GetCategoryViewModel_WhenCallNewPostSlug_ReturnExpectedCategoryViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = Constants.NewPostSlug;

            var paramGetRecent = fixture.Create<GetRecentPostsParam>();
            var posts = fixture.Create<IEnumerable<Post>>();
            var expectedCateInfos = new List<CategoryGeneral>()
            {
                new() { Id = 1, Slug = "tin-the-thao" },
                new() { Id = 2, Slug = "bong-da" }
            };
            var category = new Category { CateId = 1, Description = "description", Title = "title" };
            postService.GetRecentPostsAsync(Arg.Do<GetRecentPostsParam>(x => paramGetRecent = x)).Returns(posts);
            postService.GetCateDetailAsync(Arg.Do<string>(x => slug = x)).Returns(category);
            postService.GetCateParentsAsync(Arg.Do<string>(x => x = slug)).Returns(expectedCateInfos);

            //Act
            var actual = await service.GetCategoryViewModel(slug);

            //Assert
            Assert.Equal(posts.ToArray(), actual.Posts);
            Assert.Equal(category, actual.Category);
            Assert.Equal(category.Title, actual.Header.HeadTitle);
            Assert.Equal(category.Description, actual.Header.Description);
            Assert.Equal(category.Title, actual.Header.Title);
            Assert.Equal(category.CateId, actual.Header.CategoryId);
            Assert.False(actual.IsVideo);
        }

        [Fact]
        public async Task GetCategoryViewModel_WhenPostsIsNull_ReturnExpectedCategoryViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = Constants.VideoSlug;

            var criteria = fixture.Create<GetPostsByCateSlugsCriteria>();
            var newPosts = fixture.Create<IEnumerable<Post>>();
            var category = fixture.Create<Category>();
            IEnumerable<Post> posts = new List<Post>();
            postService.GetCateDetailAsync(Arg.Do<string>(x => slug = x)).Returns(category);

            //Act
            var actual = await service.GetCategoryViewModel(slug);

            //Assert
            Assert.Null(actual);
        }

        [Fact]
        public async Task GetMenuData_WhenCalled_ReturnExpectedMenus()
        {
            //Arrange
            var service = GetFetchDataService();
            var menuName = fixture.Create<string>();

            var expected = fixture.Create<IEnumerable<Menu>>();
            postService.GetMenuAsync(Arg.Do<string>(x => menuName = x)).Returns(expected);

            //Act
            var actual = await service.GetMenuData(MenuType.MainMenu);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetWorldCupViewModel_WhenCalled_ReturnExpectedPostViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = fixture.Create<string>();
            var first = fixture.Create<int>();
            var end = fixture.Create<int>();

            var posts = fixture.Create<IEnumerable<Post>>();
            var category = fixture.Create<Category>();
            postService.GetPostsBySlugAsync(Arg.Do<string>(x => slug = x), Arg.Do<int>(x => first = x), Arg.Do<int>(x => end = x)).Returns(posts);
            postService.GetCateDetailAsync(Arg.Do<string>(x => slug = x)).Returns(category);

            //Act
            var actual = await service.GetWorldCupViewModel();

            //Assert
            Assert.Equal(posts, actual.LastestNews);
            Assert.Equal(posts, actual.Commentary);
            Assert.Equal(posts, actual.Videos);
            Assert.Equal(category, actual.Category);
        }

        [Fact]
        public async Task GetTodayMatches_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetFetchDataService();
            var criteria = fixture.Create<GetMatchBySeasonCriteria>();

            var expected = fixture.Create<IList<Match>>();
            matchService.GetTodayMatchesAsync().Returns(expected);

            //Act
            var actual = await service.GetTodayMatches();

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetHomepageFixture_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetFetchDataService();
            var criteria = fixture.Create<GetMatchBySeasonCriteria>();
            var option = new Option
            {
                OptionId = 1,
                OptionValue = "[{\"Id\":1,\"LeagueId\":12002,\"Order\":1, \"SeasonId\":0}]"
            };
            var expectedOptionList = Helper.ParseJsonToList<FixtureHomepage>(option.OptionValue);
            var expected = fixture.Create<(League, IList<Match>)>();
            var preMatches = expected.Item2.Where(item => item.Status != MatchConstants.Finished && item.StartTime.Date >= DateTimeUtilize.UtcNow().Date).Take(20);
            var postMatches = expected.Item2.Where(item => item.Status == MatchConstants.Finished || item.Status == MatchConstants.CutInHalf).OrderByDescending(item => item.StartTime).Take(20);
            var matchExpected = preMatches.Concat(postMatches).ToList();
            var expectedResult = new List<MatchLeagueModel>();
            expectedResult.Add(new MatchLeagueModel{League = expected.Item1, Matches = expected.Item2});
            expectedResult.Add(new MatchLeagueModel{League = expected.Item1, Matches = expected.Item2});
            optionService.GetOptionAsync(Arg.Do<string>(x =>  x = "key")).Returns(option);
            matchService.GetMatchBySeasonAsync(Arg.Do<GetMatchBySeasonCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetHomepageFixture();

            //Assert
            Assert.Equal(expected.Item1, actual.First().League);
            Assert.Equal(matchExpected, actual.First().Matches);
        }

        [Fact]
        public async Task GetHomepageStanding_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetFetchDataService();
            var criteria = fixture.Create<GetLeagueAndSeasonStandingsCriteria>();
            var option = new Option
            {
                OptionId = 1,
                OptionValue = "[{\"Id\":1,\"LeagueId\":12002,\"Order\":1, \"SeasonId\":0}]"
            };
            var expectedOptionList = Helper.ParseJsonToList<FixtureHomepage>(option.OptionValue);
            var expected = fixture.Create<(League, IList<SeasonStandings>)>();
            var expectedResult = new List<MatchLeagueModel>();
            optionService.GetOptionAsync(Arg.Do<string>(x =>  x = "key")).Returns(option);
            leagueService.GetLeagueAndSeasonStandingAsync(Arg.Do<GetLeagueAndSeasonStandingsCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetHomepageStanding();

            //Assert
            Assert.Equal(expected.Item1, actual.First().League);
            Assert.Equal(expected.Item2, actual.First().Standing);
        }

        [Fact]
        public async Task GetFootballNews_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetFetchDataService();

            var postLeft = new Fixture().Create<IEnumerable<Post>>();
            var postCenter = new Fixture().Create<IEnumerable<Post>>();
            var postRight = new Fixture().Create<IEnumerable<Post>>();

            optionService.GetOptionAsync(OptionKey.FootballNewsCategories).Returns(option);
            var footballNewsCategories = Helper.ParseJsonToList<FootballNewsHomePage>(option?.OptionValue);


            postService.GetPostsBySlugAsync(footballNewsCategories[0]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postLeft);
            postService.GetPostsBySlugAsync(footballNewsCategories[1]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postCenter);
            postService.GetPostsBySlugAsync(footballNewsCategories[2]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postRight);

            List<IEnumerable<Post>> expected = new()
            {
                postLeft,
                postCenter,
                postRight
            };

            //Act
            var actual = await service.GetFootballNews();

            //Assert
            Assert.Equal(expected.Count, actual.Item2.Count);
        }

        [Fact]
        public async Task GetHomePageViewModel_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetFetchDataService();

            var paramGetRecent = new Fixture().Create<GetRecentPostsParam>();
            var post = new Fixture().Create<IEnumerable<Post>>();
            var stickyPosts = new Fixture().Create<IList<Post>>();
            var category = new Fixture().Create<Category>();
            var stickyIds = new List<int>{ 1223, 456 };
            var ids = JsonConvert.SerializeObject(stickyIds);
            postService.GetRecentPostsAsync(paramGetRecent).Returns(post);
            postService.GetPostsBySlugAsync(Constants.FootballSlug, Constants.FromFirstItem, Constants.GetEightItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.OtherPostSlug, Constants.FromFirstItem, Constants.GetFourItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.TennisSlug, Constants.FromFirstItem, Constants.GetFourItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.VideoSlug, Constants.FromFirstItem, Constants.GetTenItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.GuessSlug, Constants.FromFirstItem, Constants.GetNineItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.BackstageSlug, Constants.FromFirstItem, Constants.GetFourItems).Returns(post);
            postService.GetPostsBySlugAsync(Constants.TransferSlug, Constants.FromFirstItem, Constants.GetFourItems).Returns(post);
            postService.GetPageDetailBySlugAsync(Constants.HomeSlug).Returns(category);
            postService.GetStickyPostsAsync().Returns(stickyIds);
            postService.GetPostsByIdsAsync(ids, Constants.GetFourItems).Returns(stickyPosts);
            var postLeft = new Fixture().Create<IEnumerable<Post>>();
            var postCenter = new Fixture().Create<IEnumerable<Post>>();
            var postRight = new Fixture().Create<IEnumerable<Post>>();

            optionService.GetOptionAsync(OptionKey.FootballNewsCategories).Returns(option);
            var footballNewsCategories = Helper.ParseJsonToList<FootballNewsHomePage>(option?.OptionValue);

            postService.GetPostsBySlugAsync(footballNewsCategories[0]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postLeft);
            postService.GetPostsBySlugAsync(footballNewsCategories[1]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postCenter);
            postService.GetPostsBySlugAsync(footballNewsCategories[2]?.Slug, Constants.FromFirstItem, Constants.GetFourItems).Returns(postRight);

            //Act
            var actual = await service.GetHomePageViewModel();

            //Assert
            Assert.IsAssignableFrom<PostViewModel>(actual);
        }
        
        [Fact]
        public async Task GetEuro2024ViewModel_WhenCalled_ReturnExpectedPostViewModel()
        {
            //Arrange
            var service = GetFetchDataService();
            var slug = fixture.Create<string>();
            var first = fixture.Create<int>();
            var end = fixture.Create<int>();

            var posts = fixture.Create<IEnumerable<Post>>();
            var category = fixture.Create<Category>();
            postService.GetPostsBySlugAsync(Arg.Do<string>(x => slug = x), Arg.Do<int>(x => first = x), Arg.Do<int>(x => end = x)).Returns(posts);
            postService.GetCateDetailAsync(Arg.Do<string>(x => slug = x)).Returns(category);

            //Act
            var actual = await service.GetEuro2024ViewModel();

            //Assert
            Assert.Equal(posts, actual.LastestNews);
            Assert.Equal(posts, actual.Commentary);
            Assert.Equal(posts, actual.Videos);
        }

        #region Helpers
        private FetchDataService GetFetchDataService()
        {
            var MenuNameSettings = new Dictionary<string, string> {
                {"MenuName", "MenuName"}
            };
            configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(MenuNameSettings)
                .Build();
            postService = Substitute.For<IPostService>();
            matchService = Substitute.For<IMatchService>();
            leagueService = Substitute.For<ILeagueService>();
            optionService = Substitute.For<IOptionService>();

            var service = new FetchDataService(postService, configuration, matchService, leagueService, optionService);

            return service;
        }
        #endregion Helpers
    }
}
