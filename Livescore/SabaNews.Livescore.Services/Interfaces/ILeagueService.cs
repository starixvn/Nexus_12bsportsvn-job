namespace SabaNews.Livescore.Services.Interfaces;

using System.Collections.Generic;
using System.Threading.Tasks;
using SabaNews.Livescore.Models.League;
using SabaNews.Livescore.Models.Match;
using SabaNews.Livescore.Services.Criteria.League;

public interface ILeagueService
{
    Task<IList<League>> GetLeaguesAsync();
    Task<IList<SeasonStandings>> GetLeagueSeasonStanding(GetLeagueSeasonStandingCriteria criteria);
    Task<(League, IList<SeasonStandings>)> GetLeagueAndSeasonStandingAsync(GetLeagueAndSeasonStandingsCriteria criteria);
}