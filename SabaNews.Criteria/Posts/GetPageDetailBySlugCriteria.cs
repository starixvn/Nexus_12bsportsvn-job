namespace SabaNews.Criteria.Posts
{
    using Fanex.Data.Repository;
    using SabaNews.Core.Constants;

    public class GetPageDetailBySlugCriteria : CriteriaBase
    {
        public string Slug { get; set; }

        public override string GetSettingKey() => "get_page_detail_by_slug";

        public override bool IsValid() => !string.IsNullOrEmpty(Slug) && Slug.Length < Constants.StringLimitLength;
    }
}