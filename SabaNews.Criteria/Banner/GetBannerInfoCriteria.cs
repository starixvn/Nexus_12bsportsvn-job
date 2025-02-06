
namespace SabaNews.Criteria.Banner
{
    using Fanex.Data.Repository;

    public class GetBannerInfoCriteria : CriteriaBase
    {
        public override string GetSettingKey() => "banner_get_info";

        public override bool IsValid() => true;
    }
}
