namespace SabaNews.Criteria.Options;

using Fanex.Data.Repository;

public class GetOptionCriteria : CriteriaBase
{
    public string OptionKey { get; set; }

    public override string GetSettingKey() => "Options_GetKey";

    public override bool IsValid() => !string.IsNullOrEmpty(OptionKey);
}
