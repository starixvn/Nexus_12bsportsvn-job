namespace SabaNews.Criteria.Posts
{
    using Fanex.Data.Repository;

    public class CheckTypeCategoryCriteria : CriteriaBase
    {
        public string _Parent { get; set; }

        public int _ID { get; set; }

        public override string GetSettingKey() => "check_type_category";

        public override bool IsValid() => true;
    }
}
