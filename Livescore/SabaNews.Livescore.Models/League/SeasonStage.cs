namespace SabaNews.Livescore.Models.League
{
    public class SeasonStage
    {
        public long StageId { get; set; }
        public string StageNameEN { get; set; }
        public string StageNameVN { get; set; }
        public string StageNameCustom { get; set; }
        public string StageNameResource { get; set; }
        public byte Mode { get; set; }
        public short GroupCount { get; set; }
        public short RoundCount { get; set; }
        public short OrderIndex { get; set; }
    }
}