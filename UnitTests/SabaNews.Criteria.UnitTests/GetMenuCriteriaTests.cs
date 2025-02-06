namespace SabaNews.Criteria.UnitTests
{
    using Xunit;

    public class GetMenuCriteriaTests
    {
        [Fact]
        public void GetSettingKey_WhenCalled_ReturnExpectedSettingKey()
        {
            // Arrange
            var criteria = new GetMenuCriteria();
            var expected = "get_menu";

            // Act
            var actual = criteria.GetSettingKey();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Theory]
        [InlineData("")]
        public void IsValid_WhenCalled_ReturnFalse(string menu)
        {
            // Arrange
            var criteria = new GetMenuCriteria()
            {
                _Menu_name = menu
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
            var criteria = new GetMenuCriteria()
            {
                _Menu_name = "homepage"
            };

            // Act
            var actual = criteria.IsValid();

            // Assert
            Assert.True(actual);
        }
    }
}
