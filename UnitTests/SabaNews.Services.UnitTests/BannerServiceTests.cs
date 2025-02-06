namespace SabaNews.Services.UnitTests
{
    using AutoFixture;
    using NSubstitute;
    using SabaNews.Core.Services;
    using SabaNews.Criteria.Banner;
    using SabaNews.Models.Banner;
    using System.Threading.Tasks;
    using Xunit;

    public class BannerServiceTests
    {
        private  IBaseService baseService;

        [Fact]
        public async Task GetBannerInfoAsync_WhenCalled_ReturnExpectedBannerModel()
        {
            //Arrange
            var service = GetBannerService();
            var fixture = new Fixture();
            var expected = fixture.Create<BannerModel>();
            var criteria = new GetBannerInfoCriteria();
            baseService.GetDataEntityAsync<BannerModel>(Arg.Do<GetBannerInfoCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetBannerInfoAsync();

            //Assert
            Assert.Equal(expected, actual);
        }

        #region Helpers
        private BannerService GetBannerService()
        {
            baseService = Substitute.For<IBaseService>();
            var service = new BannerService(baseService);

            return service;
        }

        #endregion Helpers
    }
}
