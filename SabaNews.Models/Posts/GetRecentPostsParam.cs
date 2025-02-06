namespace SabaNews.Models.Posts
{
    public class GetRecentPostsParam
    {
        public int Start { get; set; }
        public int End { get; set; }
        public int PostID { get; set; }
        public int TotalIItems { get; set; }
    }
}
