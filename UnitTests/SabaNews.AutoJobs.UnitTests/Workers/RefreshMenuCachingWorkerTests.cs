namespace SabaNews.AutoJobs.UnitTests.Workers
{
    using Microsoft.Extensions.Options;
    using NSubstitute;
    using SabaNews.AutoJobs.Models;
    using SabaNews.AutoJobs.Workers;
    using SabaNews.Core.Services;
    using SabaNews.Services.Interfaces;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Xunit;

    public class RefreshMenuCachingWorkerTests
    {
        private IRefreshCachingService refreshCachingService;

        [Fact]
        public async Task ExecuteJobAsync_WhenCalled_CalledExpectedFunction()
        {
            //Arrange
            var worker = GetWorker();

            //Act
            await worker.ExecuteJobAsync();

            //Assert
            await refreshCachingService.Received().UpdateMenuCaching();
        }

        #region Helpers
        private RefreshMenuCachingWorker GetWorker()
        {
            var settings = Substitute.For<IOptionsSnapshot<List<JobSettings>>>();
            var jobSettings = new List<JobSettings>
            {
                new JobSettings
                {
                    IsEnabled = true,
                    JobName = "RefreshHomePageCaching",
                    TimeIntervalMinutes = 20
                }
            };
            settings.Value.Returns(jobSettings);
            refreshCachingService = Substitute.For<IRefreshCachingService>();
            ILogServiceProvider logService = Substitute.For<ILogServiceProvider>();
            var service = new RefreshMenuCachingWorker(refreshCachingService, settings, logService);

            return service;
        }
        #endregion Helpers
    }
}
