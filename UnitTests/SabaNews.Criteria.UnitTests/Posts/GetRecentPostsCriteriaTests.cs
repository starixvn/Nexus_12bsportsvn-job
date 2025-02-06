namespace SabaNews.Criteria.UnitTests.Posts
{
    using SabaNews.Criteria.Posts;
    using Xunit;

    public class GetRecentPostsCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new GetRecentPostsCriteria();
            var expected = "get_recent_posts";

            // Act
            var actual = criteria.GetSettingKey();

            // Assert
            Assert.Equal(expected, actual);
        }


        [Fact]
        public void IsValid_WhenCalled_ReturnTrue()
        {
            // Arrange
            var criteria = new GetRecentPostsCriteria()
            {
                Start = 0,
                End = 10,
                TotalItems = 10
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
