namespace SabaNews.Livescore.Services.Criteria.League
{
    using Fanex.Data.Repository;

    public class GetLeagueAndSeasonStandingsCriteria : CriteriaBase
    {
        public long LeagueId { get; set; }

        public long SeasonId { get; set; }

        public override string GetSettingKey() => "Livescore_League_GetLeagueAndSeasonStandings";

        public override bool IsValid() => LeagueId > 0;
    }
}
