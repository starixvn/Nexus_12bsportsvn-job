namespace SabaNews.Livescore.Models.League
{
    using System;

    public class Season
    {
        public long LeagueId { get; set; }
        public long SeasonId { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string Year { get; set; }
    }
}