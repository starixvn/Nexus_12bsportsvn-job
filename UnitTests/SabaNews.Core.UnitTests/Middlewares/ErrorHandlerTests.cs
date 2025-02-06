namespace SabaNews.Core.UnitTests.Middlewares
{
    using AutoFixture;
    using Microsoft.AspNetCore.Http;
    using NSubstitute;
    using SabaNews.Core.Middlewares;
    using SabaNews.Core.Services;
    using System;
    using System.Net;
    using System.Threading.Tasks;
    using Xunit;

    public class ErrorHandlerTests
    {
        [Fact]
        public async Task InvokeAsync_Exception_ReturnAsExpected()
        {
            // Arrange
            var fixture = new Fixture();
            var exception = fixture.Create<Exception>();
            var next = Substitute.For<RequestDelegate>();
            var logger = Substitute.For<ILogServiceProvider>();
            var httpContext = Substitute.For<HttpContext>();
            next.Invoke(Arg.Any<HttpContext>()).Returns(x => { throw exception; });
            var middleware = new ErrorHandler(next, logger);

            // Act
            await middleware.InvokeAsync(httpContext);

            // Assert
            await logger.Received().WriteExceptionSentryErrorAsync(exception);
        }

        [Fact]
        public async Task InvokeAsync_RequestSucceeded_ReturnAsExpected()
        {
            // Arrange
            var context = new DefaultHttpContext();
            var logger = Substitute.For<ILogServiceProvider>();
            var next = Substitute.For<RequestDelegate>();
            var middleware = new ErrorHandler(next, logger);

            // Act
            await middleware.InvokeAsync(context);

            // Assert
            Assert.Equal((int)HttpStatusCode.OK, context.Response.StatusCode);
        }
    }
}
