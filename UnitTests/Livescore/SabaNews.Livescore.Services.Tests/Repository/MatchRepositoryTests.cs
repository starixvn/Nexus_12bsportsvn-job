namespace SabaNews.Livescore.Services.Tests.Repository
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using AutoFixture;
    using Fanex.Data;
    using Fanex.Data.Repository;
    using NSubstitute;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Models.Team;
    using SabaNews.Livescore.Repositories;
    using Xunit;

    public class MatchRepositoryTests
    {
        private readonly IObjectDb objectDb;
        private readonly Fixture fixture;

        public MatchRepositoryTests()
        {
            DbSettingProviderManager
            .StartTestingSession()
            .Run();
            fixture = new Fixture();
            objectDb = Substitute.For<IObjectDb>();
            ObjectDbFactory.Mock((key, time, a) => objectDb);
        }

        [Fact]
        public async Task GetTodayMatchesAsync_WhenCalled_ReturnExpectedResult()
        {
            var criteria = FakeCriteria();
            var repository = new MatchRepository();

            var matches = fixture.Create<IList<Match>>();

            objectDb.QueryAsync(Arg.Any<Func<Match, League, Team, Team, Match>>(),
                splitOn: Arg.Is("LeagueId, HomeTeamId, AwayTeamId"),
                Arg.Is(criteria)
                ).Returns(matches);
            //Actual
            var actual = await repository.GetTodayMatchesAsync(criteria);

            //Assert

            Assert.Equal(matches, actual);
        }

        private ICriteria FakeCriteria()
        {
            var criteria = Substitute.For<ICriteria>();
            criteria.GetSettingKey().Returns("Livescore_Tests");
            criteria.IsValid().Returns(true);

            return criteria;
        }

        private IMultiResultReader FakeMultipleResultReader()
        {
            return Substitute.For<IMultiResultReader>();
        }
    }
}