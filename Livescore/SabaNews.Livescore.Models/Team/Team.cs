namespace SabaNews.Livescore.Models.Team;

public class Team
{
    public long TeamId { get; set; }
    public long LeagueId { get; set; }

    public string TeamNameEN { get; set; }
    public string TeamFullNameEN { get; set; }
    public string TeamNameVN { get; set; }

    public string Icon { get; set; }
    public string IconVN { get; set; }
    public int RedCard { get; set; }
    public int YellowCard { get; set; }
}