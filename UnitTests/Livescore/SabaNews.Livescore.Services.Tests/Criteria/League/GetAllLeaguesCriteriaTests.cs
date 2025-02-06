namespace SabaNews.Livescore.Services.Tests.Criteria.League
{
    using SabaNews.Livescore.Services.Criteria.League;
    using Xunit;

    public class GetAllLeaguesCriteriaTests
    {
        [Fact]
        public void GetSettingKey_Return_ExpectedStringValue()
        {
            var criteria = new GetAllLeaguesCriteria();
            var actual = criteria.GetSettingKey();
            Assert.Equal("Livescore_League_GetAll", actual);
        }

        [Fact]
        public void IsValid_Always_ReturnTrue()
        {
            var criteria = new GetAllLeaguesCriteria();
            var actual = criteria.IsValid();
            Assert.True(actual);
        }
    }
}