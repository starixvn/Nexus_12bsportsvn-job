namespace SabaNews.Models.Posts;

using SabaNews.Core.Constants;
using SabaNews.Core.Helper;
using System;
using System.Collections.Generic;
using System.Linq;

public class Post
{
    private readonly string[] dayOfWeeks = {"Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"};
    public int ID { get; set; }
    public int EditorId { get; set; }
    public string PostName { get; set; }
    public string PostTitle { get; set; }
    public string PostContent { get; set; }
    public string PostExcerpt { get; set; }
    public DateTime PostDate { get; set; }
    public DateTime PostDateGMT { get; set; }
    public DateTime PostDateModified { get; set; }
    public string FeatureImage { get; set; }
    public string Tags { get; set; }
    public string TagsSlug { get; set; }
    public string Categories { get; set; }
    public string CatesName { get; set; }
    public string CategoriesSlug { get; set; }
    public string CategoryParent { get; set; }
    public string Slug { get; set; }
    public string Type { get; set; }
    public string Metadata { get; set; }
    public int CommentCount { get; set; }
    public long AuthorId { get; set; }
    public string Author { get; set; }
    public string SeoTitle { get; set; }
    public string SeoDescription { get; set; }
    public string SchemaType { get; set; }
    public string CustomSchema { get; set; }
    public IEnumerable<ImageInfo> Images { get; set; }
    public int VideoViews { get; set; }
    public string PrimaryCategory { get; set; }
    public List<string> ListCategories { get; set; }

    public string PostTime
    {
        get
        {
            var timeSpan = DateTimeUtilize.UtcNow().DateTime - PostDateGMT;

            if (timeSpan <= TimeSpan.FromSeconds(Constants.NumberSecondsAMinute))
            {
                return string.Format("{0} giây trước", timeSpan.Seconds);
            }
            if (timeSpan <= TimeSpan.FromMinutes(Constants.NumberMinutesAHour))
            {
                return timeSpan.Minutes > 1 ? string.Format("{0} phút trước", timeSpan.Minutes) : "1 phút trước";
            }
            if (timeSpan <= TimeSpan.FromHours(Constants.NumberHoursADay))
            {
                return timeSpan.Hours > 1 ? string.Format("{0} giờ trước", timeSpan.Hours) : "1 giờ trước";
            }

            return PostDate.ToString("H:mm dd/MM/yyyy");
        }
    }

    public string PostTimeFormatSingle
    {
        get
        {
            var day = dayOfWeeks[(int)PostDate.DayOfWeek];
            return $"{day}, {PostDate.ToString("dd/MM/yyyy, HH:mm")}";
        }
    }

    public string GetImageBySize(int width)
    {
        if (Images != null && width > 0)
        {
            return Images.FirstOrDefault(i => i.Width == width)?.ImageUrl ?? FeatureImage;
        }

        return FeatureImage;
    }

    public string Uri
    {
        get
        {
            return $"{Slug}-{ID}.html";
        }
    }
    
}