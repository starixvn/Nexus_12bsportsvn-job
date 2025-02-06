namespace SabaNews.Models.ViewModel.Posts
{
    using SabaNews.Core.Models;
    using SabaNews.Models.Categories;
    using SabaNews.Models.Posts;
    using System.Collections.Generic;
    using System.Linq;

    public class BlogViewModel
    {
        public IEnumerable<Post> Posts { get; set; }
        public Category Category { get; set; }
        public IList<CategoryGeneral> CateParents { get; set; }
        public HeaderViewModel Header { get; set; }
        public PagingModel Paging { get; set; }
        public IEnumerable<Menu> Menus { get; set; }
        public Slugs Slugs { get; set; }
        public string Slug { get; set; }
        public bool IsVideo { get; set; }
        public string HeadTitle { get; set; }
        public MenuItems MenuItems { get; set; }
        public IEnumerable<Menu> GetSubMenu(int postId)
        {
            var menu = new List<Menu>();
            if (Menus.Any() && postId > 0)
            {
                var menuItem = GetMenuDetail(postId);
                menu = Menus?.Where(item => item.ParentId == menuItem?.PostId).ToList();
            }
            return menu;
        }

        public IEnumerable<Menu> GetSubMenu(string slug)
        {
            var menu = new List<Menu>();
            if (Menus.Any() && !string.IsNullOrEmpty(slug))
            {
                var menuItem =  Menus.FirstOrDefault(item => item.CateSlug == slug);
                menu = Menus?.Where(item => item.ParentId == menuItem?.PostId).ToList();
            }
            return menu;
        }

        public Menu GetMenuDetail(int postId)
        {
            return Menus.FirstOrDefault(item => item.PostId == postId);
        }

        public IEnumerable<Menu> GetCoMenu(int postId)
        {
            var menu = new List<Menu>();
            if (Menus.Any() && postId > 0)
            {
                var menuItem = GetMenuDetail(postId);
                menu = Menus?.Where(item => item.ParentId == menuItem?.ParentId).ToList();
            }
            return menu;
        }



    }
}
