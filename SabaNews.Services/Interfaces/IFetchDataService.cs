namespace SabaNews.Services.Interfaces
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Models;
    using SabaNews.Models.Home;
    using SabaNews.Models.ViewModel.Event.Euro2024;
    using SabaNews.Models.ViewModel.Event.WorldCup;
    using SabaNews.Models.ViewModel.Posts;

    public interface IFetchDataService
    {
        Task<PostViewModel> GetHomePageViewModel();

        Task<IEnumerable<Menu>> GetMenuData(string menuType);

        Task<BlogViewModel> GetCategoryViewModel(string slug);

        Task<WorldCupViewModel> GetWorldCupViewModel();

        Task<List<MatchLeagueModel>> GetHomepageFixture();
        
        Task<List<StandingLeagueModel>> GetHomepageStanding();

        Task<IList<Match>> GetTodayMatches();

        Task<Euro2024ViewModel> GetEuro2024ViewModel();
    }
}