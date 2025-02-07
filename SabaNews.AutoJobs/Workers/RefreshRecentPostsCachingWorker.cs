namespace SabaNews.AutoJobs.Workers;

using Microsoft.Extensions.Options;
using SabaNews.AutoJobs.Constants;
using SabaNews.AutoJobs.Helpers;
using SabaNews.AutoJobs.Models;
using SabaNews.Core.Services;
using SabaNews.Services.Interfaces;
using SabaNews.WinowsService.Workers;
using System.Collections.Generic;
using System.Threading.Tasks;

public class RefreshRecentPostsCachingWorker : BaseWorker
{
    private readonly IRefreshCachingService refreshCachingService;

    public RefreshRecentPostsCachingWorker(IRefreshCachingService refreshCachingService,
        IOptions<List<JobSettings>> jobSettings,
        ILogServiceProvider logService) : base(logService)
    {
        this.refreshCachingService = refreshCachingService;
        jobSetting = JobSettingHelper.GetJobConfig(jobSettings.Value, JobNames.RefreshRecentPostsCaching);
    }

    public override async Task ExecuteJobAsync()
    {
        await refreshCachingService.UpdateRecentPostsCaching();
    }
}
