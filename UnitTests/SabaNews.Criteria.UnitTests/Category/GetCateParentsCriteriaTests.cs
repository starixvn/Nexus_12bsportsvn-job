namespace SabaNews.Criteria.UnitTests.Category
{
    using SabaNews.Criteria.Category;
    using Xunit;

    public class GetCateParentsCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new GetCateParentsCriteria();
            var expected = "cate_get_parents";

            // Act
            var actual = criteria.GetSettingKey();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Theory]
        [InlineData("")]
        [InlineData("1111111111111111111111111111111111111111111111111111111111111111111111111111111111" +
            "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111" +
            "11111111111111111111111111111111111111111111111")]

        public void IsValid_WhenCalled_ReturnFalse(string slug)
        {
            // Arrange
            var criteria = new GetCateParentsCriteria()
            {
                Slug = slug
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
            var criteria = new GetCateParentsCriteria()
            {
                Slug = "slug",
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
