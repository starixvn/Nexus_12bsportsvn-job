namespace SabaNews.Livescore.Services.Interfaces
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SabaNews.Livescore.Models.League;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Services.Criteria.Match;

    public interface IMatchService
    {
        Task<(League, IList<Match>)> GetMatchBySeasonAsync(GetMatchBySeasonCriteria criteria);

        Task<IList<Match>> GetTodayMatchesAsync();
    }
}