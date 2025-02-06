namespace SabaNews.Core.Helper
{
    using System;
    using System.Globalization;
    using SabaNews.Core.Constants;

    public static class DateTimeUtilize
    {
        const int ClientTimezone = 7;


        public static string ChangeTimeZoneToClient(DateTimeOffset time)
        {
            return time.AddHours(ClientTimezone).ToString("dd MMM yyyy HH:mm:ssss");
        }

        public static string FormatDateTime(DateTimeOffset time, string Format)
        {
            return time.AddHours(ClientTimezone).ToString(Format, new CultureInfo("vi"));
        }

        public static DateTimeOffset ConvertToGMT(this DateTimeOffset time)
        {
            return time.AddHours(-ClientTimezone);
        }

        public static DateTime ConvertToGMT(this DateTime time)
            => time.AddHours(-ClientTimezone);

        public static DateTime ConvertToClient(this DateTime time)
        {
            return time.AddHours(ClientTimezone);
        }

        public static DateTimeOffset ConvertToClient(this DateTimeOffset dateTime)
            => dateTime.AddHours(ClientTimezone);

        public static DateTimeOffset DateTime(int year, int month, int day, int hour = 0, int minute = 0, int second = 0)
        {
            return new DateTimeOffset(year, month, day, hour, minute, second, TimeSpan.FromHours(Constants.ServerTimeZone));
        }

        public static DateTime ConvertToUTC(this DateTime dateTime, float timezone)
            => dateTime.AddHours(timezone > 0 ? -timezone : Math.Abs(timezone));


        public static DateTime ToStartOfDay(this DateTime date) => new DateTimeOffset(date.Year, date.Month, date.Day, 0, 0, 0, TimeSpan.FromHours(ClientTimezone)).DateTime;

        public static DateTime ToEndOfDay(this DateTime date)
        {
            const byte Hour = 23;
            const byte Minute = 59;
            return new DateTimeOffset(date.Year, date.Month, date.Day, Hour, Minute, Minute, TimeSpan.FromHours(ClientTimezone)).DateTime;
        }


        #pragma warning disable S6354
        public static DateTimeOffset UtcNow() => DateTimeOffset.UtcNow;

        public static DateTimeOffset Now() => DateTimeOffset.Now;
        #pragma warning restore S6354

    }
}
