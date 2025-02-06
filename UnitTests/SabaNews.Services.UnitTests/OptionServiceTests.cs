namespace SabaNews.Services.UnitTests
{
    using AutoFixture;
    using NSubstitute;
    using SabaNews.Core.Services;
    using SabaNews.Criteria.Options;
    using SabaNews.Models.Options;
    using System.Threading.Tasks;
    using Xunit;


    public class OptionServiceTests
    {
        private IBaseService baseService;
        private readonly IFixture fixture = new Fixture();

     
        [Fact]
        public async Task GetOptionAsync_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetOptionService();
            var key = "key";
            var criteria = fixture.Create<GetOptionCriteria>();
            var expected = fixture.Create<Option>();
            baseService.GetDataEntityAsync<Option>(Arg.Do<GetOptionCriteria>(x => criteria = x)).Returns(expected);

            //Act
            var actual = await service.GetOptionAsync(key);

            //Assert
            Assert.Equal(expected, actual);
        }
        
        #region Helpers
        private OptionService GetOptionService()
        {
            baseService = Substitute.For<IBaseService>();
            var service = new OptionService(baseService);

            return service;
        }
        #endregion Helpers
    }
}
