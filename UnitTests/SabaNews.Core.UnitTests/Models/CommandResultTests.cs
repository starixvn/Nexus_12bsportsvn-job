namespace SabaNews.Core.UnitTests.Models
{
    using SabaNews.Core.Models;
    using Xunit;

    public class CommandResultTests
    {

        [Fact]
        public void DefaultCommand_ReturnAsExpected()
        {
            // Arrange
            var command = new CommandResult();
            
            // Assert
            Assert.False(command.IsSuccessful);
        }


        [Fact]
        public void SetCommand_ReturnAsExpected()
        {
            // Arrange
            var command = new CommandResult();

            //Act 
            command.Code = 0;

            // Assert
            Assert.True(command.IsSuccessful);
        }
    }
}
