namespace SabaNews.Livescore.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Fanex.Data.Repository;
    using SabaNews.Livescore.Models.Match;

    public interface IMatchRepository
    {
        Task<IList<Match>> GetTodayMatchesAsync(ICriteria criteria);
    }
}