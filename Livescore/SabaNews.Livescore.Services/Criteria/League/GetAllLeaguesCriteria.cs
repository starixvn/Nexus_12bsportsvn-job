namespace SabaNews.Livescore.Services.Criteria.League;

using Fanex.Data.Repository;

public class GetAllLeaguesCriteria : CriteriaBase
{
    public override string GetSettingKey() => "Livescore_League_GetAll";

    public override bool IsValid() => true;
}
