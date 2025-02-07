namespace SabaNews.Core.Services;

using System;
using System.IO;
using System.Threading.Tasks;
using Fanex.Data.Repository;
using Fanex.Logging.Extensions;
using Fanex.Logging.Extensions.Database;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using NLog;
using NLog.Web;
using SabaNews.Core.Helper;

public class LogServiceProvider : ILogServiceProvider
{
    private readonly Fanex.Logging.ILogger logger;
    private readonly Logger infoLogger = NLogBuilder.ConfigureNLog("nlog.config").GetCurrentClassLogger();
    private readonly IWebHostEnvironment webHostEnvironment;
    private readonly IConfiguration configuration;
    private const int LowPerformanceRuntime = 2000;

    public LogServiceProvider(
        Fanex.Logging.ILogger logger,
        IWebHostEnvironment webHostEnvironment,
        IConfiguration configuration)
    {
        this.logger = logger;
        this.webHostEnvironment = webHostEnvironment;
        this.configuration = configuration;
    }

    public async Task WriteExceptionSentryErrorAsync(Exception exception)
    {
        var logMessage = new LogMessage(exception.Message)
                   .AddSection("Database Info", DatabaseInfoGetters.GetDbExceptionInfo(exception))
                   .AddSection("Server Info", CommonInfoGetters.GetServerInfo())
                   .AddSection("Exception Info", CommonInfoGetters.GetExceptionInfo(exception))
                   .ToString();
        await logger.ErrorAsync(logMessage);
        infoLogger.Error(logMessage);
    }

    public async Task WriteMessageSentryErrorAsync(string logMessage)
    {
        await logger.ErrorAsync(logMessage);
    }

    public void WriteLogFileInfo(string logMessage)
    {
        infoLogger.Error(logMessage);
    }

    public void WriteLogFileTrackingSP(ICriteria criteria, long runtime)
    {
        try
        {
            var filePath = Path.Combine(webHostEnvironment.ContentRootPath, "LogFiles/TrackingSP.txt");
            bool IsWiteLogFile = configuration.GetValue<bool>("IsEnableWriteLogSP");
            if (IsWiteLogFile && runtime > LowPerformanceRuntime)
            {
                if (!File.Exists(filePath))
                {
                    File.Create(filePath).Dispose();
                }
                using StreamWriter w = File.AppendText("LogFiles/TrackingSP.txt");
                LogSP(criteria, runtime, w);
            }
        }
        catch (Exception e)
        {
            _ = e.Message;
            WriteLogFileInfo(e.Message);
        }
    }

    public static void LogSP(ICriteria criteria, long runtime, TextWriter w)
    {
        var param = JsonConvert.SerializeObject(criteria);
        w.Write("\r\nDate time: ");
        w.Write($"{DateTimeUtilize.ChangeTimeZoneToClient(DateTimeUtilize.UtcNow())}");
        w.Write($" --- SP name: {criteria.GetSettingKey()} --- Runtime: {runtime} ms");
        w.Write($" --- Params: {param}");
        w.Write("\r\n-------------------------------");
    }
}