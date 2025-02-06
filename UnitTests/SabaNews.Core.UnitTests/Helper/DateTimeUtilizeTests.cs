namespace SabaNews.Core.UnitTests.Helper
{
    using SabaNews.Core.Helper;
    using System;
    using System.Globalization;
    using Xunit;

    public class DateTimeUtilizeTests
    {
        [Fact]
        public void ChangeTimeZoneToClient_ReturnAsExpected()
        {
            // Arrange
            var date = DateTime.UtcNow;
            var expected = date.Add(new TimeSpan(7, 0, 0)).ToString("dd MMM yyyy HH:mm:ssss");

            // Act
            var result = DateTimeUtilize.ChangeTimeZoneToClient(date);

            // Assert
            Assert.Equal(expected, result);
        }


        [Fact]
        public void FormatDateTime_ReturnAsExpected()
        {
            // Arrange
            var date = DateTimeOffset.UtcNow;
            var format = "dd MMM yyyy";
            var expected = date.Add(new TimeSpan(7, 0, 0)).ToString(format, new CultureInfo("vi"));

            // Act
            var result = DateTimeUtilize.FormatDateTime(date, format);

            // Assert
            Assert.Equal(expected, result);
        }

    }
}
