namespace SabaNews.Criteria.Posts;

using Fanex.Data.Repository;
using SabaNews.Core.Constants;

public class GetPostsByCateSlugCriteria : CriteriaBase
{
    public string _CategorySlug { get; set; }
    public string PostType { get; set; } = Constants.postType;
    public int _Start { get; set; }
    public int _End { get; set; }
    public int TotalItems { get; set; }

    public override string GetSettingKey() => "get_posts_by_cate_slug";

    public override bool IsValid() => !string.IsNullOrEmpty(_CategorySlug) && _CategorySlug.Length < Constants.StringLimitLength;
}
