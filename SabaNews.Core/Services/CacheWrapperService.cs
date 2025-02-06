namespace SabaNews.Core.Services
{
    using System.Threading.Tasks;
    using Fanex.Caching;
    using Newtonsoft.Json;

    public class CacheWrapperService : ICacheWrapperService
    {
        private readonly ICacheService cacheService;

        public CacheWrapperService(ICacheService cacheService)
        {
            this.cacheService = cacheService;
        }

        public async Task<T> GetAsync<T>(string key)
        {
            string jsonResult = await cacheService.GetAsync<string>(key);

            if (string.IsNullOrWhiteSpace(jsonResult))
            {
                return default;
            }

            var result = JsonConvert.DeserializeObject<T>(jsonResult);
            return result;
        }

        public async Task SetAsync<T>(string key, T data, CacheItemOptions options)
        {
            await cacheService.SetAsync(key, JsonConvert.SerializeObject(data), options);
        }

        public async Task SetAsync<T>(string key, T data)
        {
            await cacheService.SetAsync(key, JsonConvert.SerializeObject(data));
        }

        public async Task Remove(string key)
        {
            await cacheService.RemoveAsync(key);
        }
    }
}