
namespace SabaNews.Models.Home
{
    using System;

    public class FootballNewsHomePage
    {
        public string Category { get; set; }
        public int Id { get; set; }
        public string Slug { get; set; }
        public string Url { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
