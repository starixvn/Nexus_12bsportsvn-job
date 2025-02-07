namespace SabaNews.Criteria.Posts;

using Fanex.Data.Repository;
using SabaNews.Core.Constants;

public class GetTopPostsByCateSlugCriteria : CriteriaBase
{
    public string CateSlug { get; set; }

    public long PostId { get; set; }

    public int Start { get; set; }

    public int End { get; set; }

    public override string GetSettingKey() => "get_top_posts_by_cate_slug";

    public override bool IsValid() => !string.IsNullOrEmpty(CateSlug) && CateSlug.Length < Constants.StringLimitLength;
}
