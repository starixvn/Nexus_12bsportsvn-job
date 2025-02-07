namespace SabaNews.Livescore.Services;

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Interfaces;
using SabaNews.Core.Helper;
using SabaNews.Core.Services;
using SabaNews.Livescore.Models.League;
using SabaNews.Livescore.Models.Match;
using SabaNews.Livescore.Models.Team;
using SabaNews.Livescore.Repositories;
using SabaNews.Livescore.Services.Criteria.Match;

public class MatchService : IMatchService
{
    private readonly IMatchRepository matchRepository;
    private readonly IBaseService baseService;

    public MatchService(IMatchRepository matchRepository, IBaseService baseService)
    {
        this.matchRepository = matchRepository;
        this.baseService = baseService;
    }

    public async Task<(League, IList<Match>)> GetMatchBySeasonAsync(GetMatchBySeasonCriteria criteria)
    {
        (var leagues, var season, var floatMatches) = await baseService.FetchMultipleAsync<League, Season, FloatMatchModel>(criteria);
        var league = leagues.FirstOrDefault();
        if (league != null)
        {
            league.Season = season.FirstOrDefault();
        }
        
        var matches = ProcessFloatMatches(floatMatches);

        return (league, matches);
    }


    public async Task<IList<Match>> GetTodayMatchesAsync()
    {
        var today = DateTimeUtilize.UtcNow().ConvertToClient().DateTime;
        var criteria = new GetHotLeagueMatchTodayCriteria
        {
            FromTime = today.ToStartOfDay().ConvertToGMT(),
            ToTime = today.ToEndOfDay().ConvertToGMT()
        };
        return await matchRepository.GetTodayMatchesAsync(criteria);
    }


    private List<Match> ProcessFloatMatches(IEnumerable<FloatMatchModel> floatMatches)
    {
        var matches = new List<Match>();
        foreach (FloatMatchModel match in floatMatches)
        {
            var stage = match.StageId.HasValue
                ? new SeasonStage
                {
                    StageId = match.StageId.Value,
                    StageNameEN = match.StageNameEN,
                    StageNameVN = match.StageNameVN,
                    Mode = match.StageMode,
                    GroupCount = match.GroupCount,
                    RoundCount = match.RoundCount,
                    OrderIndex = match.OrderIndex
                }
                : null;
            matches.Add(new Match
            {
                MatchId = match.MatchId,
                FootballAddStartTime = match.FootballAddStartTime,
                FootballStartTime = match.FootballStartTime,
                FootballNextHalfStartTime = match.FootballNextHalfStartTime,
                StartTime = match.StartTime,
                EndTime = match.EndTime,
                Status = match.Status,
                GroupNum = match.GroupNum,
                Round = match.Round,
                HomeTeamHalfScore = match.HomeTeamHalfScore,
                AwayTeamHalfScore = match.AwayTeamHalfScore,
                HomeTeamTotalScore = match.HomeTeamTotalScore,
                AwayTeamTotalScore = match.AwayTeamTotalScore,
                HomeTeamAggregateScore = match.HomeTeamAggregateScore,
                AwayTeamAggregateScore = match.AwayTeamAggregateScore,
                HomeTeamExtraScore = match.HomeTeamExtraScore,
                AwayTeamExtraScore = match.AwayTeamExtraScore,
                HomeTeamPenaltyScore = match.HomeTeamPenaltyScore,
                AwayTeamPenaltyScore = match.AwayTeamPenaltyScore,
                HomeTeam = new Team
                {
                    TeamId = match.HomeTeamId,
                    TeamNameEN = match.HomeTeamNameEN,
                    TeamFullNameEN = match.HomeTeamFullNameEN,
                    TeamNameVN = match.HomeTeamNameVN,
                    Icon = match.HomeTeamIcon,
                    IconVN = match.HomeTeamIconVN
                },
                AwayTeam = new Team
                {
                    TeamId = match.AwayTeamId,
                    TeamNameEN = match.AwayTeamNameEN,
                    TeamFullNameEN = match.AwayTeamFullNameEN,
                    TeamNameVN = match.AwayTeamNameVN,
                    Icon = match.AwayTeamIcon,
                    IconVN = match.AwayTeamIconVN
                },
                Stage = stage,
                IsSecondLeg = match.IsSecondLeg
            });
        }
        return matches;
    }
}