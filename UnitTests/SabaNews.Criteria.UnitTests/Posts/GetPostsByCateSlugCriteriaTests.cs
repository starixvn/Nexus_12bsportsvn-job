namespace SabaNews.Criteria.UnitTests.Posts
{
    using SabaNews.Criteria.Posts;
    using Xunit;

    public class GetPostsByCateSlugCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new GetPostsByCateSlugCriteria();
            var expected = "get_posts_by_cate_slug";

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
            var criteria = new GetPostsByCateSlugCriteria()
            {
                _CategorySlug = slug,
                _Start = 0,
                _End = 10,
                TotalItems = 10
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
            var criteria = new GetPostsByCateSlugCriteria()
            {
                _CategorySlug = "slug",
                _Start = 0,
                _End = 10,
                TotalItems = 10
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
