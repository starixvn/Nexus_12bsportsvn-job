namespace SabaNews.AutoJobs.Models
{
    public class JobSettings
    {
        public string JobName { get; set; }

        public bool IsEnabled { get; set; }

        public int TimeIntervalMinutes { get; set; }
    }
}
