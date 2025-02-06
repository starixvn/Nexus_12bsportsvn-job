namespace SabaNews.Services.Interfaces
{
    using SabaNews.Models.Banner;
    using System.Threading.Tasks;

    public interface IBannerService
    {
        Task<BannerModel> GetBannerInfoAsync();
    }
}
