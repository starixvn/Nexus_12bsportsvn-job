namespace SabaNews.Services.UnitTests
{
    using AutoFixture;
    using Microsoft.Extensions.Configuration;
    using NSubstitute;
    using SabaNews.Core.Constants;
    using SabaNews.Core.Services;
    using SabaNews.Criteria;
    using SabaNews.Criteria.Posts;
    using SabaNews.Models;
    using SabaNews.Models.Options;
    using SabaNews.Models.Posts;
    using SabaNews.Resources;
    using SabaNews.Services.Interfaces;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Threading.Tasks;
    using Xunit;

    public class PostServiceTests
    {
        private IBaseService baseService;
        private ISerializerService serializerService;
        private IOptionService optionService;
        private IConfiguration configuration;
        private readonly IFixture fixture = new Fixture();

        [Fact]
        public async Task GetPostsByCateSlugAsync_WhenCalled_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var start = fixture.Create<int>();
            var end = fixture.Create<int>();
            var criteria = fixture.Create<GetPostsBySlugCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetPostsBySlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPostsBySlugAsync(slug, start, end);

            //Assert
            Assert.Equal(expected, actual);
            Assert.Equal(slug, criteria.CategorySlug);
            Assert.Equal(start, criteria.Start);
            Assert.Equal(end, criteria.End);
        }


        [Fact]
        public async Task GetPostsBySlugAsync_WhenCalled_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<GetPostsByCateSlugCriteria>();
            var criteria = fixture.Create<GetPostsByCateSlugCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetPostsByCateSlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPostsByCateSlugAsync(param);

            //Assert
            Assert.Equal(expected, actual);
            Assert.Equal(param, criteria);
        }

        [Fact]
        public async Task GetVideoPostsBySlugAsync_WhenCalled_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<GetVideoPostsBySlugCriteria>();
            var criteria = fixture.Create<GetVideoPostsBySlugCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetVideoPostsBySlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetVideoPostsBySlugAsync(param);

            //Assert
            Assert.Equal(expected, actual);
            Assert.Equal(param, criteria);
        }

        [Fact]
        public async Task GetRecentPostsAsync_WhenHavePostID_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<GetRecentPostsParam>();
            var criteria = fixture.Create<GetRecentPostsCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetRecentPostsCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetRecentPostsAsync(param);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetRecentPostsAsync_WhenCallFromSinglePage_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = new GetRecentPostsParam { PostID = 4, Start = 0, End = 3 };
            var criteria = fixture.Create<GetRecentPostsCriteria>();
            var expected = GetTestPost();
            baseService.GetDataAsync<Post>(Arg.Do<GetRecentPostsCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetRecentPostsAsync(param);

            //Assert
            Assert.Equal(expected, actual);
        }
        

        [Fact]
        public async Task GetRecentPostsAsync_WhenPostIdIsEmpty_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<GetRecentPostsParam>();
            param.PostID = 0;
            var criteria = fixture.Create<GetRecentPostsCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetRecentPostsCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetRecentPostsAsync(param);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetTopPostsByCateSlugAsync_WhenHavePostID_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<PostParam>();
            var criteria = fixture.Create<GetTopPostsByCateSlugCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetTopPostsByCateSlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetTopPostsByCateSlugAsync(param);

            //Assert
            Assert.Equal(expected.ToList(), actual);
        }

        [Fact]
        public async Task GetTopPostsByCateSlugAsync_WhenPostIdIsEmpty_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = fixture.Create<PostParam>();
            param.PostID = 0;
            var criteria = fixture.Create<GetTopPostsByCateSlugCriteria>();
            var expected = fixture.Create<IEnumerable<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetTopPostsByCateSlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetTopPostsByCateSlugAsync(param);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetTopPostsByCateSlugAsync_WhenCallFromSinglePage_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var param = new PostParam { PostID = 4, Start = 0, End = 3, Slug = "slug" };
            var criteria = fixture.Create<GetTopPostsByCateSlugCriteria>();
            var expected = GetTestPost();
            baseService.GetDataAsync<Post>(Arg.Do<GetTopPostsByCateSlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetTopPostsByCateSlugAsync(param);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPostDetailBySlugAsync_WhenHaveFullData_ReturnExpectedPost()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var postType = fixture.Create<string>();
            var criteria = fixture.Create<GetPostDetailBySlugCriteria>();
            var expected = fixture.Create<Post>();
            baseService.GetDataEntityAsync<Post>(Arg.Do<GetPostDetailBySlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPostDetailBySlugAsync(slug, postType);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPostDetailBySlugAsync_WhenExcerptIsEmpty_ReturnExpectedPost()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var postType = fixture.Create<string>();
            var criteria = fixture.Create<GetPostDetailBySlugCriteria>();
            var checkIsVideoTypecriteria = fixture.Create<CheckTypeCategoryCriteria>();
            var expected = fixture.Create<Post>();
            var expectedCategory = fixture.Create<Category>(); ;
            expected.PostExcerpt = null;
            expected.CategoriesSlug = null;
            expected.CatesName = null;
            expected.PostContent = "content\ncontent";
            baseService.GetDataEntityAsync<Post>(Arg.Do<GetPostDetailBySlugCriteria>(x => criteria = x)).Returns(expected);
            baseService.GetDataEntityAsync<Category>(Arg.Do<CheckTypeCategoryCriteria>(x => checkIsVideoTypecriteria = x)).Returns(expectedCategory);
            //Act
            var actual = await service.GetPostDetailBySlugAsync(slug, postType);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPostDetailBySlugAsync_PostTypeIsPage_ReturnExpectedPost()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var postType = "page";
            var criteria = fixture.Create<GetPostDetailBySlugCriteria>();
            var checkIsVideoTypecriteria = fixture.Create<CheckTypeCategoryCriteria>();
            var expected = fixture.Create<Post>();
            var expectedCategory = fixture.Create<Category>(); ;
            expected.PostExcerpt = null;
            expected.CategoriesSlug = null;
            expected.CatesName = null;
            expected.PostContent = "content\ncontent";
            baseService.GetDataEntityAsync<Post>(Arg.Do<GetPostDetailBySlugCriteria>(x => criteria = x)).Returns(expected);
            baseService.GetDataEntityAsync<Category>(Arg.Do<CheckTypeCategoryCriteria>(x => checkIsVideoTypecriteria = x)).Returns(expectedCategory);
            //Act
            var actual = await service.GetPostDetailBySlugAsync(slug, postType);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetCateDetailAsync_WhenCalled_ReturnExpectedCategory()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var criteria = fixture.Create<GetCateDetailCriteria>();
            var expected = fixture.Create<Category>();
            baseService.GetDataEntityAsync<Category>(Arg.Do<GetCateDetailCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetCateDetailAsync(slug);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPageDetailBySlugAsync_WhenCalled_ReturnExpectedCategory()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var criteria = fixture.Create<GetPageDetailBySlugCriteria>();
            var expected = fixture.Create<Category>();
            baseService.GetDataEntityAsync<Category>(Arg.Do<GetPageDetailBySlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPageDetailBySlugAsync(slug);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPageDetailBySlugAsync_WhenCalled_ReturnNull()
        {
            //Arrange
            var service = GetPostService();
            var slug = fixture.Create<string>();
            var criteria = fixture.Create<GetPageDetailBySlugCriteria>();
            Category expected = null;
            baseService.GetDataEntityAsync<Category>(Arg.Do<GetPageDetailBySlugCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPageDetailBySlugAsync(slug);

            //Assert
            Assert.Null(actual);
        }

        [Fact]
        public async Task GetMenuAsync_WhenCalled_ReturnExpectedMenus()
        {
            //Arrange
            var service = GetPostService();
            var menuName = fixture.Create<string>();
            var criteria = fixture.Create<GetMenuCriteria>();
            var expected = fixture.Create<IEnumerable<Menu>>();
            baseService.GetDataAsync<Menu>(Arg.Do<GetMenuCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetMenuAsync(menuName);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetNewsSitemapDataAsync_WhenCalled_ReturnExpectedNewsSitemapModel()
        {
            //Arrange
            var service = GetPostService();
            var criteria = fixture.Create<GetNewsSitemapCriteria>();
            var expected = fixture.Create<IEnumerable<NewsSitemapModel>>();
            baseService.GetDataAsync<NewsSitemapModel>(Arg.Do<GetNewsSitemapCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetNewsSitemapDataAsync();

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void PostFunction_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var expectedInSecondPost = fixture.Create<Post>();
            var expectedInMunitePost = fixture.Create<Post>();
            var expectedInHourPost = fixture.Create<Post>();
            var expectedNormalPost = fixture.Create<Post>();
            var Images = new List<ImageInfo>();
            Images.Add(new ImageInfo { ImageType = "jpg", Width = 100, Height = 100, ImageUrl = "url" });
            Images.Add(new ImageInfo { ImageType = "jpg", Width = 200, Height = 200, ImageUrl = "url" });
            expectedInSecondPost.Images = Images;
            expectedInSecondPost.PostDateGMT = DateTime.UtcNow.AddSeconds(-10);
            expectedInMunitePost.PostDateGMT = DateTime.UtcNow.AddMinutes(-10);
            expectedInHourPost.PostDateGMT = DateTime.UtcNow.AddHours(-2);
            var postDateFormat = expectedInSecondPost.PostTimeFormatSingle;
            var imageSize100 = expectedInSecondPost.GetImageBySize(100);
            var imageSize50 = expectedInSecondPost.GetImageBySize(50);
            var imageSizeInValid = expectedInSecondPost.GetImageBySize(-1);
            var imageSize = expectedInMunitePost.GetImageBySize(100);
            //Act & Assert
            Assert.Equal("10 giây trước", expectedInSecondPost.PostTime);
            Assert.Equal("10 phút trước", expectedInMunitePost.PostTime);
            Assert.Equal("2 giờ trước", expectedInHourPost.PostTime);
            Assert.NotNull(expectedNormalPost.PostTime);

            Assert.Equal(expectedInSecondPost.PostDate.ToString("dddd, dd/MM/yyyy, HH:mm", new CultureInfo("vi")), postDateFormat);
            Assert.Equal("url", imageSize100);
            Assert.Equal(expectedInSecondPost.FeatureImage, imageSize50);
            Assert.Equal(expectedInSecondPost.FeatureImage, imageSizeInValid);
            Assert.Equal(expectedInMunitePost.FeatureImage, imageSize);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedBasketballSlug()
        {
            //Arrange
            var categoriesSlug = Constants.BasketballSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.BasketballEN, actual.First().Name);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedBasketballVideoSlug()
        {
            //Arrange
            var categoriesSlug = Constants.BasketballVideoSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.BasketballEN, actual.First().Name);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedTennisSlug()
        {
            //Arrange
            var categoriesSlug = Constants.TennisSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.TennisEN, actual.First().Name);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedTennisVideoSlug()
        {
            //Arrange
            var categoriesSlug = Constants.TennisVideoSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.TennisEN, actual.First().Name);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedSearchSlug()
        {
            //Arrange
            var categoriesSlug = Constants.FootballSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.SoccerEN, actual.First().Name);
        }

        [Fact]
        public void HandleSubjects_WhenCalled_ReturnExpectedsubjects()
        {
            //Arrange
            var categoriesSlug = Constants.FootballSlug + "," + Constants.BasketballSlug;

            //Act
            var actual = PostService.HandleSubjects(categoriesSlug);

            //Assert
            Assert.Equal(ViewResources.All, actual.First().Name);
        }

        [Fact]
        public void CheckSoccer_WhenCalled_ReturnExpectedTrue()
        {
            //Arrange
            var categoriesSlug = Constants.FootballSlug;

            //Act
            var actual = PostService.CheckSoccer(categoriesSlug);

            //Assert
            Assert.True(actual);
        }

        [Fact]
        public void CheckSoccer_WhenCalled_ReturnExpectedFalse()
        {
            //Arrange
            var categoriesSlug = Constants.TennisSlug;

            //Act
            var actual = PostService.CheckSoccer(categoriesSlug);

            //Assert
            Assert.False(actual);
        }

        [Fact]
        public void CheckVideo_WhenCalled_ReturnExpectedTrue()
        {
            //Arrange
            var categoriesSlug = Constants.VideoSlug;
            //Act
            var actual = PostService.CheckVideo(categoriesSlug);

            //Assert
            Assert.True(actual);
        }

        [Fact]
        public void CheckVideo_WhenCalled_ReturnExpectedFalse()
        {
            //Arrange
            var categoriesSlug = Constants.FootballSlug;
            //Act
            var actual = PostService.CheckVideo(categoriesSlug);

            //Assert
            Assert.False(actual);
        }

        [Fact]
        public void HandleTags_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var categoriesSlug = Constants.FootballSlug + ", " + Constants.BasketballSlug;
            var expected = new List<string> { Constants.FootballSlug, Constants.BasketballSlug };
            //Act
            var actual = PostService.HandleTags(categoriesSlug);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetPostsByIdsAsync_WhenCalled_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var ids = fixture.Create<string>();
            var limit = 5;
            var criteria = fixture.Create<GetPostsByJsonIdsCriteria>();
            var expected = fixture.Create<IList<Post>>();
            baseService.GetDataAsync<Post>(Arg.Do<GetPostsByJsonIdsCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetPostsByIdsAsync(ids, limit);

            //Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task GetStickyPostsAsync_WhenHaveOptionValue_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var ids = fixture.Create<string>();
            var expectedResult = new List<int>{ 7334, 7332 };
            var expected = new ArrayList();
            expected.Add(7334);
            expected.Add(7332);
            var expectedOption = new Option
            {
                OptionName = OptionKey.StickyPost,
                OptionValue = "a:2:{i:0;i:7334;i:1;i:7332;}"
            };
            optionService.GetOptionAsync(Arg.Do<string>(x => x = OptionKey.StickyPost)).Returns(expectedOption);
            serializerService.UnserializerToArrayList(Arg.Do<string>(x => expectedOption.OptionValue = x)).Returns(expected);

            //Act
            var actual = await service.GetStickyPostsAsync();

            //Assert
            Assert.Equal(expectedResult, actual);
        }

        [Fact]
        public async Task GetStickyPostsAsync_WhenOptionIsNULL_ReturnExpectedPosts()
        {
            //Arrange
            var service = GetPostService();
            var ids = fixture.Create<string>();
            var expectedResult = new List<int>{  };
            var expected = new ArrayList();
            Option expectedOption = null;
            string optionValue = null;
            optionService.GetOptionAsync(Arg.Do<string>(x => x = OptionKey.StickyPost)).Returns(expectedOption);
            serializerService.UnserializerToArrayList(Arg.Do<string>(x => optionValue = x)).Returns(expected);

            //Act
            var actual = await service.GetStickyPostsAsync();

            //Assert
            Assert.Equal(expectedResult, actual);
        }


        private static IEnumerable<Post> GetTestPost()
        {
            List<Post> expected = new List<Post>();
            expected.Add(new Post { ID = 1, PostExcerpt = "", PostContent = "content", FeatureImage = "", Metadata = "" });
            expected.Add(new Post { ID = 2, PostExcerpt = "", PostContent = "content \n content", FeatureImage = "", Metadata = "" });
            expected.Add(new Post { ID = 3, PostExcerpt = "", PostContent = "content \n content", FeatureImage = "", Metadata = "" });
            return (IEnumerable<Post>)expected;
        }

        private static IEnumerable<Post> GetExpectedPost()
        {
            List<Post> expected = new List<Post>();
            expected.Add(new Post { ID = 1, PostExcerpt = "", PostContent = "content", FeatureImage = "", Metadata = "" });
            expected.Add(new Post { ID = 2, PostExcerpt = "", PostContent = "content \n content", FeatureImage = "", Metadata = "" });
            return (IEnumerable<Post>)expected;
        }

        #region Helpers
        private PostService GetPostService()
        {
            baseService = Substitute.For<IBaseService>();
            serializerService = Substitute.For<ISerializerService>();
            configuration = Substitute.For<IConfiguration>();
            optionService = Substitute.For<IOptionService>();
            var service = new PostService(baseService, serializerService, configuration, optionService);

            return service;
        }
        #endregion Helpers
    }
}
