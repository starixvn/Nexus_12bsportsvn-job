namespace SabaNews.Core.Services;

using System.Threading.Tasks;
using Fanex.Caching;

public interface ICacheWrapperService
{
    Task<T> GetAsync<T>(string key);

    Task SetAsync<T>(string key, T data, CacheItemOptions options);

    Task SetAsync<T>(string key, T data);

    Task Remove(string key);
}