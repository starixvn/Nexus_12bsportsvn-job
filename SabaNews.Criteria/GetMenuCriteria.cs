namespace SabaNews.Criteria
{
    using Fanex.Data.Repository;

    public class GetMenuCriteria : CriteriaBase
    {
        public string _Menu_name { get; set; }

        public override string GetSettingKey() => "get_menu";

        public override bool IsValid() => !string.IsNullOrEmpty(_Menu_name);
    }
}
