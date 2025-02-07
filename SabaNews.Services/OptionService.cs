namespace SabaNews.Services;

using SabaNews.Core.Services;
using SabaNews.Criteria.Options;
using SabaNews.Models.Options;
using SabaNews.Services.Interfaces;
using System.Threading.Tasks;

public class OptionService : IOptionService
{
    private readonly IBaseService baseService;
    public OptionService(IBaseService baseService)
    {
        this.baseService = baseService;
    }

    public async Task<Option> GetOptionAsync(string Key)
    {
        var criteria = new GetOptionCriteria { OptionKey = Key };
        var result = await baseService.GetDataEntityAsync<Option>(criteria);
        return result;
    }
}
