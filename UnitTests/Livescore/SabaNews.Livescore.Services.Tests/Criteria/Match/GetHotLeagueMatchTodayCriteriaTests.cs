namespace SabaNews.Livescore.Services.Tests.Criteria.Match
{
    using SabaNews.Livescore.Services.Criteria.Match;
    using Xunit;

    public class GetHotLeagueMatchTodayCriteriaTests
    {
        [Fact]
        public void GetSettingKey_Return_ExpectedStringValue()
        {
            var criteria = new GetHotLeagueMatchTodayCriteria();
            var actual = criteria.GetSettingKey();
            Assert.Equal("Livescore_Match_GetTodayHotLeague", actual);
        }

        [Fact]
        public void IsValid_Always_ReturnTrue()
        {
            var criteria = new GetHotLeagueMatchTodayCriteria { };
            var actual = criteria.IsValid();
            Assert.True(actual);
        }
    }
}
