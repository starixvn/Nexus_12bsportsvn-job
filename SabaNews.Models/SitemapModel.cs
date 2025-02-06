namespace SabaNews.Models
{
    using System;

    public class SitemapModel
    {
        public int ID { get; set; }

        public string Slug { get; set; }

        public string PostType { get; set; }

        public DateTime? ModifiedDate { get; set; }

        public string Url { get; set; }

        public int? Parent { get; set; }
    }
}