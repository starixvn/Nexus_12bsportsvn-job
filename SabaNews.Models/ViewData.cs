namespace SabaNews.Models;

public class ViewData
{
    public string Title { get; set; }
    public string HeadTitle { get; set; }
    public string Description { get; set; }
    public int CurrentPage { get; set; }
    public int PageSize { get; set; }
    public int TotalPages { get; set; }
    public int CategoryId { get; set; }
    public string Controller { get; set; }
    public string Keyword { get; set; }
    public string Tag { get; set; }
    public string DateSearch { get; set; }
    public string Slug { get; set; }
    public bool IsChildren { get; set; }
    public string ActiveCategory { get; set; }
}