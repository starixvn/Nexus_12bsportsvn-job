namespace SabaNews.Core.Helper;

using Newtonsoft.Json;
using System.Collections.Generic;

public static class Helper
{
    public static List<T> ParseJsonToList<T>(string data)
    {
        var result = new List<T>();
        if (data == null)
        {
            return result;
        }
        result = JsonConvert.DeserializeObject<List<T>>(data);
        return result;
    }
}
