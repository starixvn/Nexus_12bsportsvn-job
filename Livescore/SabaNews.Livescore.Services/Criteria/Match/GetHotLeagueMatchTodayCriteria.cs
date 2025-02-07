namespace SabaNews.Livescore.Services.Criteria.Match;

using System;
using Fanex.Data.Repository;
using SportTypeEnum = Services.SportType;

public class GetHotLeagueMatchTodayCriteria : CriteriaBase
{
    public DateTime FromTime { get; set; }
    public DateTime ToTime { get; set; }
    public short SportId { get; set; } = (short)SportTypeEnum.Soccer;
    public override string GetSettingKey() => "Livescore_Match_GetTodayHotLeague";

    public override bool IsValid() => true;
}
