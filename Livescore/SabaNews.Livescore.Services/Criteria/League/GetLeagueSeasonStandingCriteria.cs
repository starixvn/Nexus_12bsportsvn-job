namespace SabaNews.Livescore.Services.Criteria.League
{
    using Fanex.Data.Repository;

    public class GetLeagueSeasonStandingCriteria : CriteriaBase
    {
        public long LeagueId { get; set; }

        public long SeasonId { get; set; }


        public override string GetSettingKey() => "Livescore_League_GetSeasonStandings";

        public override bool IsValid() => LeagueId > 0 && SeasonId > 0;
    }
    
}
