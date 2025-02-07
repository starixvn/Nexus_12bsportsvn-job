namespace SabaNews.Services;

using Microsoft.Extensions.Configuration;
using SabaNews.Core.Constants;
using SabaNews.Core.Helper;
using SabaNews.Core.Services;
using SabaNews.Criteria;
using SabaNews.Criteria.Category;
using SabaNews.Criteria.Posts;
using SabaNews.Models;
using SabaNews.Models.Categories;
using SabaNews.Models.Posts;
using System;
using System.Collections.Generic;
using SabaNews.Models.ViewModel.Posts;
using SabaNews.Resources;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Collections;
using SabaNews.Services.Interfaces;

public class PostService : IPostService
{
    private readonly IBaseService baseService;
    private readonly ISerializerService serializerService;
    private readonly IOptionService optionService;

    public PostService(IBaseService baseService, 
        ISerializerService serializerService, 
        IConfiguration configuration,
        IOptionService optionService)
    {
        this.baseService = baseService;
        this.serializerService = serializerService;
        this.optionService = optionService;
    }

    public async Task<IEnumerable<Post>> GetPostsBySlugAsync(string slug, int start, int end, string postType = Constants.postType)
    {
        var criteria = new GetPostsBySlugCriteria
        {
            CategorySlug = slug?.Trim(),
            Start = start,
            End = end,
            PostType = postType
        };
        var posts = await baseService.GetDataAsync<Post>(criteria);
        return FormatData(posts).ToList();
    }

    public async Task<IEnumerable<Post>> GetPostsByCateSlugAsync(GetPostsByCateSlugCriteria criteria)
    {
        var posts = await baseService.GetDataAsync<Post>(criteria);
        return FormatData(posts).ToList();
    }

    public async Task<IEnumerable<Post>> GetVideoPostsBySlugAsync(GetVideoPostsBySlugCriteria criteria)
    {
        var posts = await baseService.GetDataAsync<Post>(criteria);
        return FormatData(posts).ToList();
    }

    public async Task<IEnumerable<Post>> GetRecentPostsAsync(GetRecentPostsParam postParam)
    {
        var criteria = new GetRecentPostsCriteria
        {
            Start = postParam.Start,
            End = postParam.End
        };
        var posts = await baseService.GetDataAsync<Post>(criteria);
        postParam.TotalIItems = criteria.TotalItems;
        return FormatData(posts).ToList();
    }

    public async Task<IEnumerable<Post>> GetTopPostsByCateSlugAsync(PostParam postParam)
    {
        var criteria = new GetTopPostsByCateSlugCriteria
        {
            CateSlug = postParam.Slug.Trim(),
            Start = postParam.Start,
            End = postParam.End,
            PostId = postParam.PostID
        };
        var posts = await baseService.GetDataAsync<Post>(criteria);

        return FormatData(posts).ToList();
    }

    public async Task<IEnumerable<Post>> GetMostViewPostsAsync(GetMostViewPostsCriteria criteria)
    {
        var posts = await baseService.GetDataAsync<Post>(criteria);

        return posts.ToList();
    }

    public async Task<Post> GetPostDetailBySlugAsync(string slug, string postType)
    {
        var criteria = new GetPostDetailBySlugCriteria
        {
            Slug = slug,
            PostType = postType
        };
        var post = await baseService.GetDataEntityAsync<Post>(criteria);
        if (post != null)  
        {
            if (string.IsNullOrEmpty(post.PostExcerpt))
            {
                var excerpt = Regex.Replace(post.PostContent, @"<[^>]+>|&nbsp;", "").Trim();
                var subTitle = excerpt.IndexOf("\n", StringComparison.OrdinalIgnoreCase);
                post.PostExcerpt = subTitle != -1 ? excerpt.Substring(0, subTitle) : excerpt;
            }
            var metadata = serializerService.Unserializer(post.Metadata);
            post.Images = GetListImageFromMetadata(metadata, post.FeatureImage);
            post.CategoriesSlug ??= "";
            post.CatesName ??= "";
        }
        return post;
    }

    public async Task<Category> GetCateDetailAsync(string slug)
    {
        var criteria = new GetCateDetailCriteria
        {
            Slug = slug
        };
        var cate = await baseService.GetDataEntityAsync<Category>(criteria);
        return ReplaceStringFromVarSeo(cate);
    }


    public async Task<Category> GetPageDetailBySlugAsync(string slug)
    {
        var criteria = new GetPageDetailBySlugCriteria
        {
            Slug = slug
        };
        var cate = await baseService.GetDataEntityAsync<Category>(criteria);
        return ReplaceStringFromVarSeo(cate);
    }

    public async Task<IEnumerable<Menu>> GetMenuAsync(string MenuName)
    {
        var criteria = new GetMenuCriteria
        {
            _Menu_name = MenuName
        };
        return await baseService.GetDataAsync<Menu>(criteria);
    }

    public async Task<IList<CategoryGeneral>> GetCateParentsAsync(string slug)
    {
        var result = await baseService.GetDataAsync<CategoryGeneral>(new GetCateParentsCriteria { Slug = slug });
        var cates = result.Reverse();
        return cates.ToList();
    }

    public static IList<Subjects> HandleSubjects(string categoriesSlug)
    {
        var subjects = new List<Subjects>();
        string[] categories = categoriesSlug.Split(new []{ "," }, StringSplitOptions.None);
        foreach(var item in categories)
        {
            if(item == Constants.BasketballSlug || 
                item == Constants.BasketballVideoSlug)
            {
                subjects.Add(new Subjects { Id = Constants.IdBasketballEN, Name = ViewResources.BasketballEN });
            }
            if (item == Constants.TennisSlug ||
                item == Constants.TennisVideoSlug)
            {
                subjects.Add(new Subjects { Id = Constants.IdTennisEN, Name = ViewResources.TennisEN });
            }
            if (CheckSoccer(item))
            {
                subjects.Add(new Subjects { Id = Constants.IdSoccerEN, Name = ViewResources.SoccerEN });
            }
        }
        if(subjects.Count > 1)
        {
            subjects = new List<Subjects> { new Subjects { Id = Constants.IdAll, Name = ViewResources.All} };
        }
        return subjects;
    }

    public static bool CheckSoccer(string category)
    {
        const string search = Constants.FootballSlug + Constants.VideoFootballSlug +
                            Constants.Euro2020VideoSlug + Constants.VideoWorldCup2022Slug +
                            Constants.VideoGuessWorldCup2022Slug + Constants.VideoHighlightWorldCup2022Slug;
        if (search.Contains(category))
        {
            return true;
        }
        return false;
    }

    public static bool CheckVideo(string categoriesSlug)
    {
        string[] categories = categoriesSlug.Split(new []{ "," }, StringSplitOptions.None);
        foreach (var item in categories.Where(cate => cate.Contains(Constants.VideoSlug)))
        {
            return true;
        }
        return false;
    }

    public static IList<string> HandleTags(string tags)
    {
        var result = new List<string>();
        string[] tagsList = tags.Split(new []{ ", " }, StringSplitOptions.None);
        tagsList.ToList().ForEach(x => result.Add(x));
        return result;
    }

    private IEnumerable<Post> FormatData(IEnumerable<Post> posts)
    {
        foreach (var post in posts.Where(item => string.IsNullOrEmpty(item.PostExcerpt)))
        {
            var excerpt = Regex.Replace(post.PostContent, @"<[^>]+>|&nbsp;", "").Trim();
            var subTitle = excerpt.IndexOf("\n", StringComparison.OrdinalIgnoreCase);
            post.PostExcerpt = subTitle != -1 ? excerpt[..subTitle] : excerpt;
        }
        return posts;
    }


    public async Task<IEnumerable<NewsSitemapModel>> GetNewsSitemapDataAsync()
    {
        return await baseService.GetDataAsync<NewsSitemapModel>(new GetNewsSitemapCriteria());
    }

    public async Task<IList<Post>> GetPostsByIdsAsync(string ids, int limitItems)
    {
        var criteria = new GetPostsByJsonIdsCriteria
        {
            Ids = ids,
            LimitItem = limitItems
        };
        var posts = await baseService.GetDataAsync<Post>(criteria);

        return posts.ToList();
    }

    public async Task<List<int>> GetStickyPostsAsync()
    {
        var setting =  await optionService.GetOptionAsync(OptionKey.StickyPost);
        var hashObject = serializerService.UnserializerToArrayList(setting?.OptionValue);
        var ids = hashObject.Cast<int>().ToList();
        return ids;
    }

    private static List<SitemapModel> GetCategoriesSiteMap(IList<SitemapModel> categories)
    {
        var cateList = new List<SitemapModel>();
        foreach (var cate in categories)
        {
            cate.Url = cate.Slug + CategoryKey.Suffix;
            cateList.Add(cate);
        }
        return cateList.ToList();
    }

    private static IEnumerable<ImageInfo> GetListImageFromMetadata(Hashtable hashTable, string featuredImage)
    {
        var results = new List<ImageInfo>();
        try
        {
            if (hashTable.Contains("sizes"))
            {
                var sizes = hashTable["sizes"];
                var sizeHash = (Hashtable)sizes;
                var imageBaseUrl = string.Join("/", featuredImage.Split('/').SkipLast(1).ToArray());
                results = MappingHashTableToListImgInfo(imageBaseUrl, sizeHash);
            }
        }
        catch
        {
            return results;
        }
        return results;
    }

    private static List<ImageInfo> MappingHashTableToListImgInfo(string imageBaseUrl, Hashtable sizeHash)
    {
        var images = new List<ImageInfo>();
        if (sizeHash != null)
        {
            #pragma warning disable S3267
            foreach (Hashtable item in sizeHash.Values)
            {
                if (IsValidKeys(item))
                {
                    images.Add(new ImageInfo
                    {
                        Width = Int32.Parse(item["width"].ToString()),
                        Height = Int32.Parse(item["height"].ToString()),
                        ImageType = item.ContainsKey("mime-type") ? (string)item["mime-type"] : string.Empty,
                        ImageUrl = string.Format("{0}/{1}", imageBaseUrl, (string)item["file"])
                    });
                }
            }
            #pragma warning restore S3267
        }
        return images;
    }

    private static bool IsValidKeys(Hashtable item)
    {
        return item.ContainsKey("width") && item.ContainsKey("height") && item.ContainsKey("file");
    }

    private static Category ReplaceStringFromVarSeo(Category cate)
    {
        var now = DateTimeUtilize.UtcNow();
        const string dateFormat = "dd/MM/yyyy";
        if (cate == null)
        {
            return cate;
        }
        if (cate.SEOTitle != null)
        {
            var result = Regex.Replace(cate.SEOTitle, Constants.SepVar, Constants.Separate, RegexOptions.IgnoreCase);
            result =  Regex.Replace(result, Constants.SiteNameVar, Constants.SiteName, RegexOptions.IgnoreCase);
            cate.SEOTitle = Regex.Replace(result, Constants.CurrentDateVar, DateTimeUtilize.FormatDateTime(now, dateFormat), RegexOptions.IgnoreCase);
        }
        if (cate.Description != null)
        {
            var result = Regex.Replace(cate.Description, Constants.SepVar, Constants.Separate, RegexOptions.IgnoreCase);
            result = Regex.Replace(result, Constants.SiteNameVar, Constants.SiteName, RegexOptions.IgnoreCase);
            cate.Description = Regex.Replace(result, Constants.CurrentDateVar, DateTimeUtilize.FormatDateTime(now, dateFormat), RegexOptions.IgnoreCase);
        }
        if (cate.OgDescription != null)
        {
            var result = Regex.Replace(cate.OgDescription, Constants.SepVar, Constants.Separate, RegexOptions.IgnoreCase);
            result = Regex.Replace(result, Constants.SiteNameVar, Constants.SiteName, RegexOptions.IgnoreCase);
            cate.OgDescription = Regex.Replace(result, Constants.CurrentDateVar, DateTimeUtilize.FormatDateTime(now, dateFormat), RegexOptions.IgnoreCase);
        }
        if (cate.OgTitle != null)
        {
            var result = Regex.Replace(cate.OgTitle, Constants.SepVar, Constants.Separate, RegexOptions.IgnoreCase);
            result = Regex.Replace(result, Constants.SiteNameVar, Constants.SiteName, RegexOptions.IgnoreCase);
            cate.OgTitle = Regex.Replace(result, Constants.CurrentDateVar, DateTimeUtilize.FormatDateTime(now, dateFormat), RegexOptions.IgnoreCase);
        }

        return cate;
    }
}