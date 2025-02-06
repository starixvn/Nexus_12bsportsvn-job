namespace SabaNews.Livescore.Services.Criteria.League
{
    using Fanex.Data.Repository;

    public class GetLeaguesCriteria : CriteriaBase
    {
        public override string GetSettingKey() => "Livescore_League_Get";

        public override bool IsValid() => true;
    }
}
