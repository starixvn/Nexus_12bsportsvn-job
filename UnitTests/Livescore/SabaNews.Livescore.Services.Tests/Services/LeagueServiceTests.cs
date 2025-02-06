namespace SabaNews.Livescore.Services.Tests.Services
{
    using AutoFixture;
    using NSubstitute;
    using SabaNews.Core.Services;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Services.Criteria.League;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Xunit;

    public class LeagueServiceTests
    {
        private IBaseService baseService;
        
        [Fact]
        public async Task GetLeaguesAsync_WhenCalled_ReturnExpectedResult()
        {
            //Arrange
            var service = GetService();
            var fixture = new Fixture();
            var leagues = fixture.Create<IList<League>>();
            baseService.GetDataAsync<League>(Arg.Any<GetLeaguesCriteria>()).Returns(leagues);
            //Act
            var actual = await service.GetLeaguesAsync();
            //Assert
            Assert.Equal(leagues, actual);
        }
        
        [Fact]
        public async Task GetLeagueSeasonStanding_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetService();
            var fixture = new Fixture();
            var criteria = fixture.Create<GetLeagueSeasonStandingCriteria>();
            var standings = fixture.Create<IList<SeasonStandings>>();
            baseService.GetDataAsync<SeasonStandings>(Arg.Any<GetLeagueSeasonStandingCriteria>()).Returns(standings);
            //Act
            var actual = await service.GetLeagueSeasonStanding(criteria);
            //Assert
            Assert.Equal(standings, actual);
        }

        [Fact]
        public async Task GetLeagueAndSeasonStandingAsync_WhenCalled_ReturnExpectedData()
        {
            //Arrange
            var service = GetService();
            var fixture = new Fixture();
            var criteria = fixture.Create<GetLeagueAndSeasonStandingsCriteria >();
            (var league, var standing) = fixture.Create<(IEnumerable<League>, IEnumerable<SeasonStandings>)>();
            baseService.FetchMultipleAsync<League, SeasonStandings>(Arg.Do<GetLeagueAndSeasonStandingsCriteria>(x => x = criteria)).Returns((league, standing));
            //Act
            var actual = await service.GetLeagueAndSeasonStandingAsync(criteria);
            //Assert
            Assert.Equal(standing, actual.Item2);
        }
        
        [Fact]
        public void GetLeaguePriority_WhenCalled_ReturnExpectedResult()
        {
            //Arrange
            var fixture = new Fixture();
            var league = fixture.Create<IList<League>>();

            //Act
            var actual = LeagueService.GetLeaguePriority(league);
            int priority = 0;
            foreach(var item in league)
            {
                if(item.Priority > priority)
                {
                    priority = item.Priority;
                }
            }
            //Assert
            Assert.Equal(priority + 1, actual);
        }

        private LeagueService GetService()
        {
            baseService = Substitute.For<IBaseService>();

            return new LeagueService(baseService);
        }
    }
}