namespace SabaNews.Services.Interfaces
{
    using SabaNews.Models.Options;
    using System.Threading.Tasks;

    public interface IOptionService
    {
        Task<Option> GetOptionAsync(string Key);
    }
}
