namespace SabaNews.Models.Home;

using SabaNews.Livescore.Models.League;
using SabaNews.Livescore.Models.Match;
using System.Collections.Generic;

public class MatchLeagueModel
{
    public League League { get; set; }
    public IList<Match> Matches {get;set;}
}
