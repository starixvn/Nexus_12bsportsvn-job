namespace SabaNews.Criteria
{
    using Fanex.Data.Repository;
    
    public class GetNewsSitemapCriteria : CriteriaBase
    {
        public override string GetSettingKey() => "get_sitemap_news";

        public override bool IsValid() => true;
    }
}
