namespace SabaNews.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SabaNews.Core.Constants;
    using SabaNews.Criteria.Posts;
    using SabaNews.Models;
    using SabaNews.Models.Categories;
    using SabaNews.Models.Posts;

    public interface IPostService
    {
        Task<IEnumerable<Post>> GetPostsBySlugAsync(string slug, int start, int end, string postType = Constants.postType);

        Task<IEnumerable<Post>> GetPostsByCateSlugAsync(GetPostsByCateSlugCriteria criteria);
        Task<IEnumerable<Post>> GetVideoPostsBySlugAsync(GetVideoPostsBySlugCriteria criteria);

        Task<IEnumerable<Post>> GetRecentPostsAsync(GetRecentPostsParam postParam);

        Task<IEnumerable<Post>> GetTopPostsByCateSlugAsync(PostParam postParam);

        Task<IEnumerable<Post>> GetMostViewPostsAsync(GetMostViewPostsCriteria criteria);

        Task<Post> GetPostDetailBySlugAsync(string slug, string postType);

        Task<IEnumerable<Menu>> GetMenuAsync(string MenuName);

        Task<Category> GetCateDetailAsync(string slug);

        Task<Category> GetPageDetailBySlugAsync(string slug);

        Task<IEnumerable<NewsSitemapModel>> GetNewsSitemapDataAsync();

        Task<IList<CategoryGeneral>> GetCateParentsAsync(string slug);

        Task<IList<Post>> GetPostsByIdsAsync(string ids, int limitItems);

        Task<List<int>> GetStickyPostsAsync();

    }
}