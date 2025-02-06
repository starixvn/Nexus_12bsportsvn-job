namespace SabaNews.Livescore.Models.Match
{
    using System.Collections.Generic;

    public class SeasonStandings
    {
        public long StageId { get; set; }
        public string StageNameEN { get; set; }
        public string StageNameVN { get; set; }
        public short OrderIndex { get; set; }

        public long TeamId { get; set; }
        public string TeamNameEN { get; set; }
        public string TeamFullNameEN { get; set; }
        public string TeamNameVN { get; set; }
        public string Icon { get; set; }
        public string IconVN { get; set; }

        public string GroupName { get; set; }
        public short Position { get; set; }
        public short Total { get; set; }
        public short Won { get; set; }
        public short Loss { get; set; }
        public short Draw { get; set; }

        public object Promotion { get; set; }

        public short Points { get; set; }
        public short Goals { get; set; }
        public short GoalsAgainst { get; set; }
        public short GoalDiff { get; set; }

        public IList<FloatMatchModel> Matches { get; set; }
    }
}