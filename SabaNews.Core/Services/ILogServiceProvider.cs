namespace SabaNews.Core.Services
{
    using Fanex.Data.Repository;
    using System;
    using System.Threading.Tasks;

    public interface ILogServiceProvider
    {
        Task WriteExceptionSentryErrorAsync(Exception exception);

        Task WriteMessageSentryErrorAsync(string logMessage);

        void WriteLogFileInfo(string logMessage);

        void WriteLogFileTrackingSP(ICriteria criteria, long runtime);
    }
}
