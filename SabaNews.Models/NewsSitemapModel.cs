namespace SabaNews.Models;

using System;

public class NewsSitemapModel
{
    public long ID { get; set; }

    public string Slug { get; set; }

    public string Title { get; set; }

    public DateTime? ModifiedDate { get; set; }

    public string Tags { get; set; }

    public string Uri
    {
        get
        {
            return $"{Slug}-{ID}.html";
        }
    }
}
