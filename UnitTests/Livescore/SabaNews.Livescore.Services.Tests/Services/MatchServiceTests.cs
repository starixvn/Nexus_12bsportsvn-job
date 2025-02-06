namespace SabaNews.Livescore.Services.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AutoFixture;
    using Fanex.Data.Repository;
    using NSubstitute;
    using SabaNews.Core.Services;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Repositories;
    using SabaNews.Livescore.Services.Criteria.Match;
    using Xunit;

    public class MatchServiceTests
    {
        private readonly IBaseService baseService;
        private readonly IMatchRepository matchRepository;
        private readonly Fixture fixture;
        private readonly MatchService matchService;

        public MatchServiceTests()
        {
            baseService = Substitute.For<IBaseService>();
            matchRepository = Substitute.For<IMatchRepository>();
            fixture = new Fixture();
            matchService = new MatchService(matchRepository, baseService);
        }

        [Fact]
        public async Task GetMatchBySeasonAsync_WhenCalled_ReturnExpectedResult()
        {
            (var leagues, var season, var floatMatches) = fixture.Create<(IEnumerable<League>, IEnumerable<Season>, IEnumerable<FloatMatchModel>)>();
            baseService.FetchMultipleAsync<League, Season, FloatMatchModel>(Arg.Any<ICriteria>()).Returns((leagues, season, floatMatches));

            var actual = await matchService.GetMatchBySeasonAsync(new GetMatchBySeasonCriteria());
            Assert.Equal(leagues.FirstOrDefault(), actual.Item1);
            Assert.Equal(floatMatches.Count(), actual.Item2.Count);
        }
    }
}