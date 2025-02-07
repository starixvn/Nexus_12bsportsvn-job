namespace SabaNews.AutoJobs.Workers;

using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using SabaNews.AutoJobs.Constants;
using SabaNews.AutoJobs.Helpers;
using SabaNews.AutoJobs.Models;
using SabaNews.Core.Services;
using SabaNews.Services.Interfaces;
using SabaNews.WinowsService.Workers;

public class RefreshHomePageCachingWorker : BaseWorker
{
    private readonly IRefreshCachingService refreshCachingService;

    public RefreshHomePageCachingWorker(IRefreshCachingService refreshCachingService,
        IOptions<List<JobSettings>> jobSettings,
        ILogServiceProvider logService) : base(logService)
    {
        this.refreshCachingService = refreshCachingService;
        jobSetting = JobSettingHelper.GetJobConfig(jobSettings.Value, JobNames.RefreshHomePageCaching);
    }

    public override async Task ExecuteJobAsync()
    {
        await refreshCachingService.UpdateHomePageCaching();
    }
}