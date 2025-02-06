ARG CI_REGISTRY_IMAGE

FROM $CI_REGISTRY_IMAGE:builder AS deps

RUN mkdir -p /src/packages

FROM hub.nexdev.net/base/dotnet/core/sdk:8.0-alpine AS builder

ENV NUGET_PACKAGES=/src/packages

COPY --from=deps $NUGET_PACKAGES/. $NUGET_PACKAGES/

WORKDIR /src

COPY ["nuget.config", "."]
COPY ["SabaNews.AutoJobs/SabaNews.AutoJobs.csproj", "SabaNews.AutoJobs/"]
COPY ["SabaNews.Services/SabaNews.Services.csproj", "SabaNews.Services/"]
COPY ["SabaNews.Models/SabaNews.Models.csproj", "SabaNews.Models/"]
COPY ["SabaNews.Core/SabaNews.Core.csproj", "SabaNews.Core/"]
COPY ["SabaNews.Criteria/SabaNews.Criteria.csproj", "SabaNews.Criteria/"]

RUN dotnet nuget add source https://nuget.nexdev.net/api/v2

RUN dotnet restore "SabaNews.AutoJobs/SabaNews.AutoJobs.csproj"

COPY . .

WORKDIR "/src/SabaNews.AutoJobs"

RUN dotnet publish -r linux-x64 --self-contained false -o /app

FROM hub.nexdev.net/base/dotnet/core/aspnet:8.0-alpine-25h1 AS base

WORKDIR /app

COPY --from=builder /app .

ENTRYPOINT ["dotnet", "SabaNews.AutoJobs.dll"]