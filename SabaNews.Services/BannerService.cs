namespace SabaNews.Services
{
    using System.Threading.Tasks;
    using SabaNews.Core.Services;
    using SabaNews.Criteria.Banner;
    using SabaNews.Models.Banner;
    using SabaNews.Services.Interfaces;

    public class BannerService : IBannerService
    {
        private readonly IBaseService baseService;

        public BannerService(IBaseService baseService)
        {
            this.baseService = baseService;
        }

        public async Task<BannerModel> GetBannerInfoAsync()
        {
            var banner = await baseService.GetDataEntityAsync<BannerModel>(new GetBannerInfoCriteria());
            return banner;
        }
    }
}