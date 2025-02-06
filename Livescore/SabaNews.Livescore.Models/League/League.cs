using System;

namespace SabaNews.Livescore.Models.League
{
    public class League
    {
        public long LeagueId { get; set; }

        public string LeagueNameEN { get; set; }
        public string CountryIconVN { get; set; }
        public string LeagueFullNameEN { get; set; }
        public string CountryLogo { get; set; }
        public string LeagueNameVN { get; set; }

        public string Icon { get; set; }
        public string IconVN { get; set; }

        public byte LeagueType { get; set; }

        public short CurrentRound { get; set; }
        public short RoundCount { get; set; }

        public bool IsMajor { get; set; }
        public int Priority { get; set; }
        public DateTime CreatedDate { get; set; }

        public bool HasSeasonStandings { get; set; }

        public Season Season { get; set; }
        public SeasonStage Stage { get; set; }
        public Country Country { get; set; }
        public string CountryEN { get; set; }
        public string CountryVN { get; set; }

        public long? CurrentSeasonId { get; set; }
        public long CurrentStageId { get; set; }
        public string Year { get; set; }

    }
}