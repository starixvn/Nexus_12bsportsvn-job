namespace SabaNews.Criteria.Posts
{
    using Fanex.Data.Repository;

    public class GetMostViewPostsCriteria : CriteriaBase
    {
        public int StartRow { get; set; }

        public int RowLimit { get; set; }

        public override string GetSettingKey() => "post_get_mostView";

        public override bool IsValid() => true;
    }
}
