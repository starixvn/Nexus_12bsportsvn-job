namespace SabaNews.Criteria.Posts;

using Fanex.Data.Repository;

public class GetRecentPostsCriteria : CriteriaBase
{
    public int Start { get; set; }

    public int End { get; set; }

    public int TotalItems { get; set; }

    public override string GetSettingKey() => "get_recent_posts";

    public override bool IsValid() => true;
}
