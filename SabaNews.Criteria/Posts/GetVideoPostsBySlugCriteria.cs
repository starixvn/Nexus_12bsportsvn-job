namespace SabaNews.Criteria.Posts
{
    using Fanex.Data.Repository;
    using SabaNews.Core.Constants;

    public class GetVideoPostsBySlugCriteria : CriteriaBase
    {
        public string CateSlug { get; set; }
        public string PostType { get; set; } = Constants.postType;
        public int StartItem { get; set; }
        public int LimitRows { get; set; }

        public override string GetSettingKey() => "post_video_get_by_slug";

        public override bool IsValid() => !string.IsNullOrEmpty(CateSlug) && CateSlug.Length < Constants.StringLimitLength;
    }
}
