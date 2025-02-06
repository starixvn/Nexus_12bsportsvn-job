using SabaNews.Livescore.Services.Criteria.League;
using Xunit;

namespace SabaNews.Livescore.Services.Tests.Criteria.League
{
    public class GetLeagueSeasonStandingCriteriaTests
    {
        [Fact]
        public void GetSettingKey_Return_ExpectedStringValue()
        {
            var criteria = new GetLeagueSeasonStandingCriteria();
            var actual = criteria.GetSettingKey();
            Assert.Equal("Livescore_League_GetSeasonStandings", actual);
        }

        [Fact]
        public void IsValid_Always_ReturnTrue()
        {
            var criteria = new GetLeagueSeasonStandingCriteria { LeagueId = 1, SeasonId = 1 };
            var actual = criteria.IsValid();
            Assert.True(actual);
        }

        [Fact]
        public void IsValid_Always_ReturnFalse()
        {
            var criteria = new GetLeagueSeasonStandingCriteria { LeagueId = 0, SeasonId = 0 };
            var actual = criteria.IsValid();
            Assert.False(actual);
        }
    }
}
