namespace SabaNews.Criteria.Posts
{
    using Fanex.Data.Repository;
    using SabaNews.Core.Constants;

    public class GetPostsBySlugCriteria : CriteriaBase
    {
        public string CategorySlug { get; set; }

        public string PostType { get; set; } = Constants.postType;

        public int Start { get; set; }

        public int End { get; set; }

        public override string GetSettingKey() => "get_posts_by_slug";

        public override bool IsValid() => !string.IsNullOrEmpty(CategorySlug) && CategorySlug.Length < Constants.StringLimitLength;
    }
}
