namespace SabaNews.Criteria.UnitTests.Posts
{
    using SabaNews.Criteria.Posts;
    using Xunit;

    public class CheckTypeCategoryCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new CheckTypeCategoryCriteria();
            var expected = "check_type_category";

            // Act
            var actual = criteria.GetSettingKey();

            // Assert
            Assert.Equal(expected, actual);
        }


        [Fact]
        public void IsValid_WhenCalled_ReturnTrue()
        {
            // Arrange
            var criteria = new CheckTypeCategoryCriteria()
            {
                _Parent = "parent",
                _ID = 1
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
