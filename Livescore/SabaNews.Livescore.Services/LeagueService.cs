namespace SabaNews.Livescore.Services
{
    using SabaNews.Core.Services;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Services.Criteria.League;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Interfaces;

    public class LeagueService : ILeagueService
    {
        private readonly IBaseService baseService;
        public LeagueService(IBaseService baseService)
        {
            this.baseService = baseService;
        }


        public async Task<IList<League>> GetLeaguesAsync()
        {
            var leagues = await baseService.GetDataAsync<League>(new GetLeaguesCriteria());
            return leagues.ToList();
        }

        public static int GetLeaguePriority(IList<League> leagues)
        {
            int priority = 0;
            foreach(var item in leagues.Where(val => val.Priority > priority))
            {
                priority = item.Priority;
            }
            return priority + 1;
        }

        public async Task<IList<SeasonStandings>> GetLeagueSeasonStanding(GetLeagueSeasonStandingCriteria criteria)
        {
            var result = await baseService.GetDataAsync<SeasonStandings>(criteria);
            return result.ToList();
        }

        public async Task<(League, IList<SeasonStandings>)> GetLeagueAndSeasonStandingAsync(GetLeagueAndSeasonStandingsCriteria criteria)
        {
            (var leagues,  var standings) = await baseService.FetchMultipleAsync<League, SeasonStandings>(criteria);
            var league = leagues.FirstOrDefault();
            return (league, standings.ToList());
        }
    }
}