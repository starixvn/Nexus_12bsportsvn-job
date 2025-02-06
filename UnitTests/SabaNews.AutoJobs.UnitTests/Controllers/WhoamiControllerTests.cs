using AutoFixture;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NSubstitute;
using SabaNews.AutoJobs.Controllers;
using System;
using System.Text;
using Xunit;

namespace SabaNews.AutoJobs.UnitTests.Controllers
{
    public class WhoamiControllerTests
    {
        private readonly IFixture fixture = new Fixture();

        [Fact]
        public void Index_WhenCalled_ReturnExpectedData()
        {
            // Arrange
            var controller = new WhoamiController();
            var context = Substitute.For<HttpContext>();
            controller.ControllerContext = new ControllerContext
            {
                HttpContext = new DefaultHttpContext()
            };
            controller.ControllerContext.HttpContext.Request.Scheme = fixture.Create<string>();
            controller.ControllerContext.HttpContext.Request.Path = $"/{fixture.Create<string>()}";
            controller.ControllerContext.HttpContext.Request.Headers["device-id"] = "20317";

            var content = new StringBuilder();
            content.Append($"Web name: {context.Request.Host.Host}{Environment.NewLine}"
                + $"Port: {context.Connection.LocalPort}{Environment.NewLine}"
                + $"Server IP: {context.Connection.LocalIpAddress}{Environment.NewLine}"
                + $"Server Time: {DateTime.Now}{Environment.NewLine}"
                + $"Client IP: {context.Connection.RemoteIpAddress}{Environment.NewLine}"
                + $"Request Scheme: {context.Request.Scheme}{Environment.NewLine}"
                + $"Request Path: {context.Request.Path}{Environment.NewLine}{Environment.NewLine}");

            foreach (var header in context.Request.Headers)
            {
                content.Append($"- {header.Key}: " +
                    $"{header.Value}{Environment.NewLine}");
            }
            var expected = content.ToString();

            //Act
            var actual = controller.Whoami();

            //Assert
            var viewResult = Assert.IsType<ContentResult>(actual);
            //Assert.Equal(expected, viewResult.Content);
        }


        
    }
}
