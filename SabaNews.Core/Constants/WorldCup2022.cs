namespace SabaNews.Core.Constants;

using SabaNews.Core.Models;
using System.Collections.Generic;

public static class WorldCup2022
{
    public const string Homepage = "Trang chủ";
    public const string TitleHomepage = "World Cup 2022: Tin tức, Lịch thi đấu, Kết quả, Bảng xếp hạng - SABA Sports";

    public const string HomepageSlug = "world-cup-2022";

    public const string LastestNews = "Tin mới nhất";
    public const string TitleLastestNews = "Tin mới nhất World Cup 2022 hôm nay - SABA Sports";

    public const string LastestNewsSlug = "tin-tuc-world-cup-2022";
    public const string UrlLastestNewsSlug = "tin-moi-nhat";

    public const string Fixture = "Lịch thi đấu";
    public const string TitleFixture = "Lịch thi đấu World Cup 2022 - SABA Sports";

    public const string FixtureSlug = "lich-thi-dau-world-cup-2022";
    public const string UrlFixtureSlug = "lich-thi-dau";

    public const string Standing = "Bảng xếp hạng";
    public const string TitleStanding = "Bảng xếp hạng World Cup 2022 - SABA Sports";

    public const string StandingSlug = "bang-xep-hang-world-cup-2022";
    public const string UrlStandingSlug = "bang-xep-hang";

    public const string Commentary = "Nhận định";
    public const string TitleCommentary = "Nhận định World Cup 2022 hôm nay - SABA Sports";

    public const string CommentarySlug = "nhan-dinh-world-cup-2022";
    public const string UrlCommentarySlug = "nhan-dinh";

    public const string Video = "Video";
    public const string TitleVideo = "Video World Cup 2022 hôm nay - SABA Sports";

    public const string VideoSlug = "video-world-cup-2022";
    public const string UrlVideoSlug = "video";

    public const string VideoHighlightSlug = "video-highlights-world-cup-2022";

    public const string VideoGuessSlug = "video-du-doan-world-cup-2022";

    public const string Minigame = "Minigame";
    public const string TitleMinigame = "Sự kiện World Cup 2022 - DỰ ĐOÁN HAY QUÀ LIỀN TAY";

    public const string MinigameSlug = "minigame-world-cup-2022";
    public const string UrlMinigameSlug = "su-kien-du-doan-sung-nhan-qua-khung";
    public const string TitleMinigameSlug = "Sự kiện World Cup 2022 - DỰ ĐOÁN HAY QUÀ LIỀN TAY";

    public const string StoryPost = "Story post";
    public const string TitleStoryPost = "Stories World Cup 2022 - SABA Sports";

    public const string StoryPostSlug = "story-post-world-cup-2022";
    public const string UrlStoryPostSlug = "stories";

    public const string Overview = "Tổng quan";
    public const string OverviewPageSlug = "danh-sach-san-thi-dau-vong-chung-ket-euro-2020";
    public const string OverviewRoute = "tong-quan";

    public const string LockStage = "Chưa diễn ra";
    public const string BeforeStartedStage = "Sắp diễn ra";
    public const string OnStartedStage = "Đang diễn ra";
    public const string BeforeEndStage = "Sắp kết thúc";
    public const string OnEndStage = "Đã kết thúc";

    public const string IconLock = "icon-icon_lock";
    public const string IconWinner = "icon-minigame_list_user";
    public const string IconStanding = "icon-minigame_standing";

    public const long LeagueIdWorldCup2022 = 14638;
    public const long SeasonIdWorldCup2022 = 10810;
    public const long LeagueIdAFFCup = 14844;
    public const long SeasonIdAFFCup = 11277;
    public const long GroupStageId = 30537;

    public const string TimestampMinigameStage01Start = "11/16/2022, 8:00:00 AM";
    public const string TimestampMinigameStage02Start = "11/22/2022, 8:00:00 AM";
    public const string TimestampMinigameStage03Start = "11/26/2022, 8:00:00 AM";
    public const string TimestampMinigameStage04Start = "11/30/2022, 8:00:00 AM";

    public const long ThirdPlace = 30541;
    public const long FinalStage = 30542;
    public const long SemifinalsStage = 30540;
    public const long QuarterfinalsStage = 30539;

    public const int MinigameScoreOthers = 10;
    public const int MinigameScoreQuarterfinal = 12;
    public const int MinigameScoreSemifinal = 15;
    public const int MinigameScoreFinal = 15;

    public const byte MinigameStage1 = 1;
    public const byte MinigameStage2 = 2;
    public const byte MinigameStage3 = 3;
    public const byte MinigameStage4 = 4;


    public static readonly IReadOnlyList<CateInfo> Menus = new List<CateInfo>
    {
        new CateInfo { Name = Homepage, Slug = "" },
        new CateInfo { Name = LastestNews, Slug = UrlLastestNewsSlug },
        new CateInfo { Name = Fixture, Slug = UrlFixtureSlug },
        new CateInfo { Name = Standing, Slug = UrlStandingSlug },
        new CateInfo { Name = Commentary, Slug = UrlCommentarySlug },
        new CateInfo { Name = Video, Slug = UrlVideoSlug },
        new CateInfo { Name = Minigame, Slug = UrlMinigameSlug }
    };

    public static readonly IReadOnlyList<CateInfo> Cates = new List<CateInfo>
    {
        new CateInfo { Name = Homepage, Slug = HomepageSlug, Url = $"/{HomepageSlug}" },
        new CateInfo { Name = LastestNews, Slug = LastestNewsSlug, Url = $"/{HomepageSlug}/{UrlLastestNewsSlug}" },
        new CateInfo { Name = Commentary, Slug = CommentarySlug, Url = $"/{HomepageSlug}/{UrlCommentarySlug}" },
        new CateInfo { Name = Video, Slug = VideoSlug, Url = $"/{HomepageSlug}/{UrlVideoSlug}" }
    };
}
