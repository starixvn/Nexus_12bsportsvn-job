namespace SabaNews.Core.Models;

using SabaNews.Core.Constants;

public class CommandResult
{
    public int Code { get; set; } = 1;
    public string Message { get; set; } = Constants.InvalidData;
    public bool IsSuccessful => Code == 0;
}
