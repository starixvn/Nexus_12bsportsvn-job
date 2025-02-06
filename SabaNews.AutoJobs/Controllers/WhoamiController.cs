namespace SabaNews.AutoJobs.Controllers
{
    using System;
    using Microsoft.AspNetCore.Mvc;
    using System.Text;
    using Microsoft.AspNetCore.Authorization;
    using SabaNews.Core.Helper;

    public class WhoamiController : Controller
    {
        [Route("whoami")]
        [AllowAnonymous]
        public IActionResult Whoami()
        {
            var stringContent = new StringBuilder();
            stringContent.Append($"Web name: {HttpContext.Request.Host.Host}{Environment.NewLine}"
                + $"Port: {HttpContext.Connection.LocalPort}{Environment.NewLine}"
                + $"Server IP: {HttpContext.Connection.LocalIpAddress}{Environment.NewLine}"
                + $"Server Time: {DateTimeUtilize.Now()}{Environment.NewLine}"
                + $"Client IP: {HttpContext.Connection.RemoteIpAddress}{Environment.NewLine}"
                + $"Request Scheme: {HttpContext.Request.Scheme}{Environment.NewLine}"
                + $"Request Path: {HttpContext.Request.Path}{Environment.NewLine}{Environment.NewLine}"
                + $"Request Headers:{Environment.NewLine}");

            foreach (var header in HttpContext.Request.Headers)
            {
                stringContent.Append($"- {header.Key}: " +
                    $"{header.Value}{Environment.NewLine}");
            }

            return Content(stringContent.ToString());
        }
    }
}
