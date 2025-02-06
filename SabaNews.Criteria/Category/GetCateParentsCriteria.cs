namespace SabaNews.Criteria.Category
{
    using Fanex.Data.Repository;
    using SabaNews.Core.Constants;

    public class GetCateParentsCriteria : CriteriaBase
    {
        public string Slug { get; set; }

        public override string GetSettingKey() => "cate_get_parents";

        public override bool IsValid() => !string.IsNullOrEmpty(Slug) && Slug.Length < Constants.StringLimitLength;
    }
}
