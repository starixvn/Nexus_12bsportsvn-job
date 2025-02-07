using System.Collections.Generic;
using SabaNews.Core.Models;

namespace SabaNews.Core.Constants;

public class Euro2024
{
    public const string HomepageSlug = "euro-2024";
    public const string Homepage = "Trang chủ";
    public const string HomepageTitle = "Euro 2024 - Tin tức, lịch thi đấu, kết quả, BXH mới nhất";
    public const string HomepageDescription = "Cập nhật thông tin bóng đá Euro 2024 mới nhất hôm nay, lịch thi đấu, kết quả, bảng xếp hạng, highlights, nhận định, link xem trực tiếp Euro 2024.";


    public const string LastestNews = "Tin mới nhất";
    public const string LastestNewsTitle = "Tin tức mới nhất về Euro 2024 | SABA Sports";
    public const string LastestNewsDescription = "Tin tức Euro 2024 mới nhất. SABAVN cập nhật liên tục về các trận đấu, các đội tuyển, cầu thủ và những thông tin hấp dẫn khác của Euro 2024.";
    public const string LastestNewsSlug = "euro-2024";
    public const string UrlLastestNewsSlug = "tin-moi-nhat";

    public const string Fixture = "Lịch thi đấu";
    public const string FixtureDescription = "Lịch thi đấu Euro 2024 mới nhất hôm nay. Xem lịch thi đấu bóng đá Euro 2024 đêm nay, LTĐ Euro 2024 rạng sáng mai.";
    public const string FixtureTitle = "Lịch thi đấu Euro 2024 chính xác nhất";
    public const string FixtureSlug = "lich-thi-dau";
    public const string UrlFixtureSlug = "lich-thi-dau";

    public const string Standing = "Bảng xếp hạng";
    public const string StandingTitle = "Bảng xếp hạng vòng chung kết Euro 2024 mới nhất hôm nay";
    public const string StandingDescription = "Xem bảng xếp hạng Euro 2024 nhanh và chính xác nhất, theo dõi tỷ số, thống kê, đội hình, diễn biến các trận đấu trên SABA Sports.";
    public const string StandingSlug = "bang-xep-hang";
    public const string UrlStandingSlug = "bang-xep-hang";

    public const string Commentary = "Nhận định";
    public const string CommentaryTitle = "Nhận định bóng đá, dự đoán tỷ số bóng đá Euro 2024";
    public const string CommentaryDescription = "Nhận định Euro 2024 hôm nay - Cập nhật tỷ lệ, thông tin trận đấu, chuyên gia nhận định và dự đoán tỷ số bóng đá chính xác nhất.";
    public const string CommentarySlug = "nhan-dinh-euro-2024";
    public const string UrlCommentarySlug = "nhan-dinh";

    public const string Video = "Video";
    public const string VideoTitle = "Video clip bàn thắng, highlights các trận đấu Euro 2024";
    public const string VideoDescription = "Video Euro 2024 mới nhất. Tổng hợp clip bàn thắng và highlights đáng chú ý trong các trận đấu thuộc Euro 2024.";
    public const string VideoSlug = "video-euro-2024";
    public const string UrlVideoSlug = "video";

    public const string Team = "Đội tuyển";
    public const string TeamSlug = "doi-tuyen";
    public const string TeamTitle = "Thông tin đầy đủ về các đội tuyển tham gia Euro 2024";
    public const string TeamDescription = "Thông tin đội tuyển Euro chi tiết, danh sách cầu thủ, huấn luyện viên, đội hình 24 đội tuyển thi đấu tại vòng chung kết Euro 2024.";



    public const long LeagueId = 12015;
    public const long SeasonId = 11334;
    public const long GroupStageId = 35455;

    public const long EightTeamStage  = 35537;
    public const long QuarterfinalsStage = 35539;
    public const long SemifinalsStage = 35538;
    public const long FinalStage = 35540;
    
    
    public const string PollKey = "poll_euro_2024";
    public const int PollTheme = 1;

    public const string HostUrl =  "ai-la-chu-nha-euro-2024-294271.html";
    public const string StadiumUrl = "tat-tan-tat-ve-cac-san-van-dong-to-chuc-euro-2024-294265.html";
    public const string BallUrl = "bong-thi-dau-euro-2024-294294.html";
    public const string MascotUrl = "linh-vat-euro-2024-nguon-goc-va-y-nghia-289380.html";
    public const string RecordUrl = "ky-luc-giai-bong-da-euro-294250.html";

    public const string TimestampMinigameStage01Start = "06/14/2024, 8:00:00 AM";
    public const string TimestampMinigameStage02Start = "06/27/2024, 8:00:00 AM";
    public const string TitleMinigame = "Minigame Euro 2024 - Dự đoán hay, hàng hiệu trao tay";
    public const string DescriptionMinigame = "Minigame Euro 2024 - Dự đoán hay, hàng hiệu trao tay";


    public const string LockStage = "Chưa diễn ra";
    public const string BeforeStartedStage = "Sắp diễn ra";
    public const string OnStartedStage = "Đang diễn ra";
    public const string BeforeEndStage = "Sắp kết thúc";
    public const string OnEndStage = "Đã kết thúc";

    public const string IconLock = "icon-icon_lock";
    public const string IconWinner = "icon-minigame_list_user";
    public const string IconStanding = "icon-icon-minigame_standing_full";

    public const string MinigameSlug = "minigame";
    public const string Minigame = "Minigame";
    public const string MinigameTitle = "Minigame Euro 2024 - Dự đoán hay, hàng hiệu trao tay";
    public const string MinigameDescription = "Minigame Euro 2024 - Dự đoán hay, hàng hiệu trao tay";


    public const int maxCountStage = 2;
    public const byte MinigameStage1 = 1;
    public const byte MinigameStage2 = 2;

    public const int MinigameScoreOthers = 10;
    public const int MinigameScoreQuarterfinal = 12;
    public const int MinigameScoreSemifinal = 15;
    public const int MinigameScoreFinal = 20;

    public static readonly List<string> startStages = new() {
            TimestampMinigameStage01Start,
            TimestampMinigameStage02Start};
    
    public static readonly List<int> NumberMatch = new() {36, 15};
    public static readonly List<int> indexMatches = new() { 35, 50 };

    public static readonly IReadOnlyList<CateInfo> Menus = new List<CateInfo>
    {
        new() { Name = Homepage, Slug = "" },
        new() { Name = Minigame, Slug = MinigameSlug, Url = $"/{HomepageSlug}/{MinigameSlug}" },
        new() { Name = LastestNews, Slug = UrlLastestNewsSlug },
        new() { Name = Fixture, Slug = UrlFixtureSlug },
        new() { Name = Standing, Slug = UrlStandingSlug },
        new() { Name = Commentary, Slug = UrlCommentarySlug },
        new() { Name = Video, Slug = UrlVideoSlug },
        new() { Name = Team, Slug = TeamSlug }
    };

    public static readonly IReadOnlyList<CateInfo> CateSlugs = new List<CateInfo>
    {
        new() { Name = Homepage, Slug = HomepageSlug, Url = $"/{HomepageSlug}" },
        new() { Name = LastestNews, Slug = LastestNewsSlug, Url = $"/{HomepageSlug}/{UrlLastestNewsSlug}" },
        new() { Name = Commentary, Slug = CommentarySlug, Url = $"/{HomepageSlug}/{UrlCommentarySlug}" },
        new() { Name = Video, Slug = VideoSlug, Url = $"/{HomepageSlug}/{UrlVideoSlug}" }
    };

    public static readonly IReadOnlyList<KeyValue> TeamProfiles = new List<KeyValue>
    {
        new() { Id = 33172, Name = "doi-tuyen-bong-da-albania" },
        new() { Id = 35611, Name = "doi-tuyen-bong-da-anh" },
        new() { Id = 33152, Name = "doi-tuyen-bong-da-quoc-gia-ao-tai-euro" },
        new() { Id = 33151, Name = "doi-tuyen-bong-da-ba-lan" },
        new() { Id = 33157, Name = "doi-tuyen-bong-da-bi" },
        new() { Id = 33169, Name = "doi-tuyen-bong-da-bo-dao-nha" },
        new() { Id = 33149, Name = "doi-tuyen-bong-da-quoc-gia-croatia-tai-euro" },
        new() { Id = 33163, Name = "doi-tuyen-bong-da-ch-sec" },
        new() { Id = 33124, Name = "doi-tuyen-bong-da-dan-mach" },
        new() { Id = 33144, Name = "doi-tuyen-bong-da-duc-tu-thang-tram-qua-khu-den-euro-2024" },
        new() { Id = 33587, Name = "doi-tuyen-bong-da-georgia" },
        new() { Id = 33155, Name = "doi-tuyen-bong-da-ha-lan" },
        new() { Id = 33136, Name = "doi-tuyen-bong-da-hungary" },
        new() { Id = 33734, Name = "doi-tuyen-bong-da-italy" },
        new() { Id = 45378, Name = "doi-tuyen-bong-da-phap" },
        new() { Id = 36617, Name = "doi-tuyen-bong-da-romania" },
        new() { Id = 33154, Name = "doi-tuyen-bong-da-scotland" },
        new() { Id = 33168, Name = "doi-tuyen-bong-da-serbia" },
        new() { Id = 33148, Name = "doi-tuyen-bong-da-slovakia" },
        new() { Id = 33150, Name = "doi-tuyen-bong-da-slovenia" },
        new() { Id = 33125, Name = "doi-tuyen-bong-da-tay-ban-nha" },
        new() { Id = 33122, Name = "doi-tuyen-bong-da-thuy-si" },
        new() { Id = 33171, Name = "doi-tuyen-bong-da-tho-nhi-ky" },
        new() { Id = 33166, Name = "doi-tuyen-bong-da-ukraine" },

    };
}