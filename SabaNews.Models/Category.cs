namespace SabaNews.Models;

public class Category
{
    public int CateId { get; set; }
    public string Name { get; set; }
    public int ParentId { get; set; }
    public string Slug { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public string OgImage { get; set; }
    public string OgDescription { get; set; }
    public string OgTitle { get; set; }
    public string SEOTitle { get; set; }
    public string Url { get; set; }
    public int? CateParentId { get; set; }
    public string CateParentName { get; set; }
    public string CustomSchema { get; set; }
    public long LeagueId { get; set; }
    public long SeasonId { get; set; }
}