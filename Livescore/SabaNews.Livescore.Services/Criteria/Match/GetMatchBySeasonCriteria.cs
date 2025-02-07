namespace SabaNews.Livescore.Services.Criteria.Match;

using System;
using Fanex.Data.Repository;

public class GetMatchBySeasonCriteria : CriteriaBase
{
    public long LeagueId { get; set; }
    public long SeasonId { get; set; }
    public DateTime? FromTime { get; set; }
    public DateTime? ToTime { get; set; }

    public override string GetSettingKey() => "Livescore_Match_GetBySeason";

    public override bool IsValid() => LeagueId > 0;
}