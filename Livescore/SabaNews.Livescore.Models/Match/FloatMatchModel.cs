namespace SabaNews.Livescore.Models.Match;

using System;

public class FloatMatchModel
{
    public long MatchId { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }

    public long HomeTeamId { get; set; }
    public string HomeTeamNameVN { get; set; }
    public string HomeTeamNameEN { get; set; }
    public string HomeTeamFullNameEN { get; set; }
    public string HomeTeamIcon { get; set; }
    public string HomeTeamIconVN { get; set; }

    public long AwayTeamId { get; set; }
    public string AwayTeamNameVN { get; set; }
    public string AwayTeamNameEN { get; set; }
    public string AwayTeamFullNameEN { get; set; }
    public string AwayTeamIcon { get; set; }
    public string AwayTeamIconVN { get; set; }

    public long? StageId { get; set; }
    public string StageNameEN { get; set; }
    public string StageNameVN { get; set; }
    public byte StageMode { get; set; }
    public short GroupCount { get; set; }
    public short RoundCount { get; set; }
    public short OrderIndex { get; set; }

    public short? GroupNum { get; set; }
    public short? Round { get; set; }
    public short Status { get; set; }
    public short HomeTeamHalfScore { get; set; }
    public short AwayTeamHalfScore { get; set; }
    public short HomeTeamTotalScore { get; set; }
    public short AwayTeamTotalScore { get; set; }
    public short HomeTeamExtraScore { get; set; }
    public short AwayTeamExtraScore { get; set; }
    public short? HomeTeamAggregateScore { get; set; }
    public short? AwayTeamAggregateScore { get; set; }
    public short? HomeTeamPenaltyScore { get; set; }
    public short? AwayTeamPenaltyScore { get; set; }
    public DateTime? FootballStartTime { get; set; }
    public DateTime? FootballNextHalfStartTime { get; set; }
    public DateTime? FootballAddStartTime { get; set; }
    public bool IsSecondLeg { get; set; }
}