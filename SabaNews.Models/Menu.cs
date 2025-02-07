namespace SabaNews.Models;

public class Menu
{
    public int PostId { get; set; }
    public string PostTitle { get; set; }
    public int CateId { get; set; }
    public string CateTitle { get; set; }
    public string CateSlug { get; set; }
    public int ParentId { get; set; }
    public string PageSlug { get; set; }
    public string PageTitle { get; set; }
    public string CustomLink { get; set; }

    public string MenuTitle
    {
        get
        {
            var title = PostTitle;
            if (string.IsNullOrEmpty(PostTitle))
            {
                title = CateTitle;
            }
            if (string.IsNullOrEmpty(PostTitle) && string.IsNullOrEmpty(CateTitle))
            {
                title = PageTitle;
            }
            return title;
        }
    }

    public string Slug
    {
        get
        {
            return string.IsNullOrEmpty(CateSlug) ? PageSlug : CateSlug;
        }
    }
}
