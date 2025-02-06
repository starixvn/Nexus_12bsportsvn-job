namespace SabaNews.Core.Models
{
    using System;


    public class PagingModel
    {
        public int CurrentPage { get; set; }

        public int PageSize { get; set; }

        public int TotalPages { get; set; }

        public string Href { get; set; }

        public string  SearchValue { get; set; }

        public DateTime FromDate { get; set; }

        public DateTime ToDate { get; set; }
    }
}
