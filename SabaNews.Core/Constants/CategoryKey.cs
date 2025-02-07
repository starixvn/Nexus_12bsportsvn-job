using System.Collections.Generic;
using SabaNews.Core.Models;

namespace SabaNews.Core.Constants;

public static class CategoryKey
{
    public const string Football = "bong-da";

    public const string Vietnam = "bong-da-viet-nam";

    public const string Europe = "giai-dau-cap-clb";

    public const string England = "bong-da-anh";

    public const string TBN = "bong-da-tbn";

    public const string Italia = "bong-da-italia";

    public const string France = "bong-da-phap";

    public const string Germany = "bong-da-duc";

    public const string International = "doi-tuyen";

    public const string NewPostSlug = "tin-the-thao";

    public const string GuessSlug = "nhan-dinh-bong-da";

    public const string BackstageSlug = "hau-truong";

    public const string TransferSlug = "chuyen-nhuong";

    public const string OtherPostSlug = "the-thao";

    public const string VideoSlug = "video";

    public const string VNFootballSlug = "bong-da-viet-nam";

    public const string ClubSlug = "giai-dau-cap-clb";

    public const string CountrySlug = "doi-tuyen";

    public const string AreaSlug = "khu-vuc";

    public const string Prefix = "category-";

    public const string Suffix = "-sabavn";

    public const string HotNewsTag = "diem-tin-bong-da-hom-nay";

    public const int ShowLivescore = 1;
    public const int HideLivescore = 0;

    public static readonly IReadOnlyList<CateSlugRedirect> CateRedirectList = new List<CateSlugRedirect>
    {
        new CateSlugRedirect { OldSlug = "viet-nam-sabavn", NewSlug = "bong-da-viet-nam-sabavn" },
        new CateSlugRedirect { OldSlug = "anh-sabavn", NewSlug = "bong-da-anh-sabavn" },
        new CateSlugRedirect { OldSlug = "tay-ban-nha-sabavn", NewSlug = "bong-da-tbn-sabavn" },
        new CateSlugRedirect { OldSlug = "cup-chau-au-sabavn", NewSlug = "giai-dau-cap-clb-sabavn" },
        new CateSlugRedirect { OldSlug = "champions-league-sabavn", NewSlug = "c1-champions-league-sabavn" },
        new CateSlugRedirect { OldSlug = "europa-league-sabavn", NewSlug = "c2-europa-league-sabavn" },
        new CateSlugRedirect { OldSlug = "conference-league-sabavn", NewSlug = "c3-conference-league-sabavn" },
        new CateSlugRedirect { OldSlug = "duc-sabavn", NewSlug = "bong-da-duc-sabavn" },
        new CateSlugRedirect { OldSlug = "italia-sabavn", NewSlug = "bong-da-italia-sabavn" },
        new CateSlugRedirect { OldSlug = "phap-sabavn", NewSlug = "bong-da-phap-sabavn" },
        new CateSlugRedirect { OldSlug = "quoc-te-sabavn", NewSlug = "doi-tuyen-sabavn" },
        new CateSlugRedirect { OldSlug = "cac-mon-khac-sabavn", NewSlug = "the-thao-sabavn" },
        new CateSlugRedirect { OldSlug = "nhan-dinh-cup-c1-sabavn", NewSlug = "nhan-dinh-c1-champions-league-sabavn" },
        new CateSlugRedirect { OldSlug = "nhan-dinh-cup-c2-sabavn", NewSlug = "nhan-dinh-c2-europa-league-sabavn" },
    };
}