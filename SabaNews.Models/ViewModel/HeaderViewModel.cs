namespace SabaNews.Models.ViewModel
{
    public class HeaderViewModel
    {
        public int CategoryId { get; set; }
        public string CategorySlug { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string HeadTitle { get; set; }
        public string Controller { get; set; }
        public string Slug { get; set; }
        public bool IsChildren { get; set; }
        public string ActiveCategory { get; set; }
        public string Keyword { get; set; }
    }
}
