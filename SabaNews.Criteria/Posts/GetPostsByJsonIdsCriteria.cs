using Fanex.Data.Repository;

namespace SabaNews.Criteria.Posts;

public  class GetPostsByJsonIdsCriteria : CriteriaBase
{
    public string Ids { get; set; }

    public int LimitItem { get; set; }

    public override string GetSettingKey() => "post_get_by_jsonIds";

    public override bool IsValid() => LimitItem > 0;
}
