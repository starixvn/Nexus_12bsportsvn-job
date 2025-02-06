namespace SabaNews.Criteria.UnitTests.Posts
{
    using SabaNews.Criteria.Posts;
    using Xunit;

    public class GetPostsBySlugCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new GetPostsBySlugCriteria();
            var expected = "get_posts_by_slug";

            // Act
            var actual = criteria.GetSettingKey();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Theory]
        [InlineData("")]
        public void IsValid_WhenCalled_ReturnFalse(string slug)
        {
            // Arrange
            var criteria = new GetPostsBySlugCriteria()
            {
                CategorySlug = slug,
                Start = 0,
                End = 10
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.False(actual);
        }

        [Fact]
        public void IsValid_WhenCalled_ReturnTrue()
        {
            // Arrange
            var criteria = new GetPostsBySlugCriteria()
            {
                CategorySlug = "slug",
                Start = 0,
                End = 10
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
