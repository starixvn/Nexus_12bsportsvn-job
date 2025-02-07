namespace SabaNews.WinowsService.Workers;

using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using SabaNews.AutoJobs.Models;
using SabaNews.Core.Services;

public class BaseWorker : BackgroundService
{
    private readonly ILogServiceProvider logService;
    private Timer timer;
    private bool isRunning;
    protected JobSettings jobSetting;

    public BaseWorker(ILogServiceProvider logService)
    {
        this.logService = logService;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        timer = new Timer(Execute,
           null,
           TimeSpan.Zero,
           TimeSpan.FromMinutes(jobSetting.TimeIntervalMinutes));

        await Task.CompletedTask;
    }

    public override Task StartAsync(CancellationToken cancellationToken)
    {
        logService.WriteLogFileInfo($"{jobSetting.JobName}: Service Starting");
        return base.StartAsync(cancellationToken);
    }

    private void Execute(object state)
    {
        try
        {
            if (!isRunning && jobSetting.IsEnabled)
            {
                isRunning = true;
                logService.WriteLogFileInfo($"{jobSetting.JobName}: Doing...");
                _ = ExecuteJobAsync();
                logService.WriteLogFileInfo($"{jobSetting.JobName}: Done.");
            }
        }
        catch (Exception ex)
        {
            logService.WriteLogFileInfo($"{jobSetting.JobName}: Error - {ex}");
        }
        finally
        {
            isRunning = false;
        }
    }

    public virtual async Task ExecuteJobAsync()
    {
        await Task.CompletedTask;
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        logService.WriteLogFileInfo($"{jobSetting.JobName}: Stopping Service");
        timer?.Change(Timeout.Infinite, 0);

        await base.StopAsync(cancellationToken);
    }

    public override void Dispose()
    {
        logService.WriteLogFileInfo($"{jobSetting.JobName}: Disposing Service");
        timer.Dispose();
        GC.SuppressFinalize(this);
        base.Dispose();
    }
}