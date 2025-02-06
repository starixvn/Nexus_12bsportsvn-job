using Fanex.Data.MySql;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using SabaNews.AutoJobs;
using SabaNews.Core.Middlewares;

var builder = WebApplication.CreateBuilder(args);

var services = builder.Services;
var configuration = builder.Configuration;

services.AddFanexSql(configuration);
services.AddControllers();
services.AddDependencyInjection();
services.AddConfiguration(configuration);
services.AddWorker();

var app = builder.Build();

app.UseMiddleware<ErrorHandler>();
app.UseRouting();

app.MapControllerRoute(
    "default",
    "{controller=Home}/{action=Index}/{id?}");

await app.RunAsync();