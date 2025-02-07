namespace SabaNews.Models.ViewModel.Posts;

using SabaNews.Models.Banner;
using SabaNews.Models.Home;
using SabaNews.Models.Posts;
using System.Collections.Generic;

public class PostViewModel
{
    public IEnumerable<Post> NewPosts { get; set; }
    public IEnumerable<Post> FootballPosts { get; set; }
    public IEnumerable<Post> OtherPosts { get; set; }
    public IEnumerable<Post> TennisPosts { get; set; }
    public IEnumerable<Post> VideoPosts { get; set; }
    public IEnumerable<Post> GuessPosts { get; set; }
    public IEnumerable<Post> BackstagePosts { get; set; }
    public IEnumerable<Post> TransferPosts { get; set; }
    public IEnumerable<Post> Hotnews { get; set; }
    public IList<Post> StickyPosts { get; set; }
    public Category Category { get; set; }
    public string Url { get; set; }
    public string RSSUrl { get; set; }
    public string PollKey { get; set; }
    public HeaderViewModel Header { get; set; }
    public BannerModel Banner { get; set; }
    public List<FootballNewsHomePage> FootballNewCategory { get; set; }
    public List<IEnumerable<Post>> LeaguePosts { get; set; }
}