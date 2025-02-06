namespace SabaNews.Livescore.Services.Tests.Criteria.Match
{
    using SabaNews.Livescore.Services.Criteria.Match;
    using Xunit;

    public class GetMatchBySeasonCriteriaTests
    {
        [Fact]
        public void GetSettingKey_Return_ExpectedStringValue()
        {
            var criteria = new GetMatchBySeasonCriteria();
            var actual = criteria.GetSettingKey();
            Assert.Equal("Livescore_Match_GetBySeason", actual);
        }

        [Fact]
        public void IsValid_InValidParam_ReturnFalse()
        {
            var criteria = new GetMatchBySeasonCriteria();
            var actual = criteria.IsValid();
            Assert.False(actual);
        }

        [Fact]
        public void IsValid_ValidParam_ReturnTrue()
        {
            var criteria = new GetMatchBySeasonCriteria { LeagueId = 1, FromTime = null, ToTime = null, SeasonId = 10000 };
            var actual = criteria.IsValid();
            Assert.True(actual);
        }
    }
}