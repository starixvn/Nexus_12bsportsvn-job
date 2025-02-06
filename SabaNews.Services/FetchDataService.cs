namespace SabaNews.Services
{
    using Microsoft.Extensions.Configuration;
    using SabaNews.Core.Constants;
    using SabaNews.Core.Constants.Livescore;
    using SabaNews.Core.Helper;
    using SabaNews.Core.Models;
    using SabaNews.Criteria.Posts;
    using SabaNews.Livescore.Models.Match;
    using SabaNews.Livescore.Services.Criteria.League;
    using SabaNews.Livescore.Services.Criteria.Match;
    using SabaNews.Models;
    using SabaNews.Models.Home;
    using SabaNews.Models.Posts;
    using SabaNews.Models.ViewModel;
    using SabaNews.Models.ViewModel.Event.Euro2024;
    using SabaNews.Models.ViewModel.Event.WorldCup;
    using SabaNews.Models.ViewModel.Posts;
    using SabaNews.Services.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Livescore.Services.Interfaces;

    public class FetchDataService : IFetchDataService
    {
        private readonly IPostService postService;
        private readonly IConfiguration configuration;
        private readonly IMatchService matchService;
        private readonly ILeagueService leagueService;
        private readonly IOptionService optionService;

        public FetchDataService(
            IPostService postService,
            IConfiguration configuration,
            IMatchService matchService,
            ILeagueService leagueService,
            IOptionService optionService)
        {
            this.postService = postService;
            this.configuration = configuration;
            this.matchService = matchService;
            this.leagueService = leagueService;
            this.optionService = optionService;
        }

        public async Task<PostViewModel> GetHomePageViewModel()
        {
            var paramGetRecent = new GetRecentPostsParam
            {
                Start = Constants.FromFirstItem,
                End = Constants.GetTenItems
            };
            var hotnewsCriteria = new GetPostsByTagCriteria
            {
                _Tag =  CategoryKey.HotNewsTag,
                _Start = Constants.FromFirstItem,
                _End = Constants.GetFourItems
            };
            IList<Post> stickyPosts = new List<Post>();
            var newPosts = await postService.GetRecentPostsAsync(paramGetRecent);
            var otherPosts = await postService.GetPostsBySlugAsync(Constants.NewOtherPostSlug, Constants.FromFirstItem, Constants.GetEightItems);
            var videoPosts = await postService.GetPostsBySlugAsync(Constants.VideoSlug, Constants.FromFirstItem, Constants.GetTenItems);
            var guessPosts = await postService.GetPostsBySlugAsync(Constants.GuessSlug, Constants.FromFirstItem, Constants.GetNineItems);
            var backstagePosts = await postService.GetPostsBySlugAsync(Constants.BackstageSlug, Constants.FromFirstItem, Constants.GetEightItems);
            var transferPosts = await postService.GetPostsBySlugAsync(Constants.TransferSlug, Constants.FromFirstItem, Constants.GetEightItems);
            var stickyPostIds = await postService.GetStickyPostsAsync();
            var category = await postService.GetPageDetailBySlugAsync(Constants.HomeSlug);
            var hotNews = await postService.GetMostViewPostsAsync(new GetMostViewPostsCriteria { StartRow = Constants.FromFirstItem, RowLimit = Constants.GetFourItems });
            var pollOption = await optionService.GetOptionAsync(OptionKey.PollHomepage);
            if(stickyPostIds.Any())
            {
                var ids = string.Join(",", stickyPostIds);
                stickyPosts = await postService.GetPostsByIdsAsync(ids, Constants.GetFourItems);
                newPosts = newPosts.Where(n => stickyPosts.All(s => s.ID != n.ID)).ToList();
                newPosts = stickyPosts.Concat(newPosts).Take(Constants.GetElevenItems).ToList();
            }

            var (footballNewUrls,leaguePosts) = await GetFootballNews();

            var viewModel = new PostViewModel
            {
                NewPosts = newPosts,
                LeaguePosts = leaguePosts,
                OtherPosts = otherPosts,
                VideoPosts = videoPosts,
                GuessPosts = guessPosts,
                BackstagePosts = backstagePosts,
                TransferPosts = transferPosts,
                Category = category,
                FootballNewCategory = footballNewUrls,
                StickyPosts = stickyPosts,
                Hotnews = hotNews,
                PollKey = pollOption?.OptionValue
            };

            return viewModel;
        }

        public async Task<BlogViewModel> GetCategoryViewModel(string slug)
        {
            var pageSize = Constants.Perpage;
            var controller = "category";
            if (slug == Constants.VideoSlug)
            {
                controller = "video";
            }
            const int start = Constants.FromFirstItem;
            IEnumerable<Post> posts;
            var totalItems = 0;
            var cate = await postService.GetCateDetailAsync(slug);
            if(cate == null)
            {
                return null;
            }
            var cateParents = await postService.GetCateParentsAsync(slug);
            var IsVideo = cateParents.Any(cate => cate.Slug == Constants.VideoSlug);
            if (slug == Constants.NewPostSlug)
            {
                var paramGetRecent = new GetRecentPostsParam
                {
                    Start = start,
                    End = pageSize
                };
                posts = await postService.GetRecentPostsAsync(paramGetRecent);
                totalItems = Constants.MaxTotalPost;
            }
            else if(IsVideo)
            {
                var criteriaVideo = new GetVideoPostsBySlugCriteria
                {
                    CateSlug = slug,
                    StartItem = start,
                    LimitRows = pageSize

                };
                posts = await postService.GetVideoPostsBySlugAsync(criteriaVideo);
            }
            else
            {
                var criteriaCategory = new GetPostsByCateSlugCriteria
                {
                    _CategorySlug = slug,
                    _Start = start,
                    _End = pageSize

                };
                posts = await postService.GetPostsByCateSlugAsync(criteriaCategory);
                totalItems = criteriaCategory.TotalItems;
            }
            if (!posts.Any())
            {
                return null;
            }
           
            var title = cate.SEOTitle ??= cate.Title;
            pageSize = slug == Constants.VideoSlug ? Constants.PageSizeVideo : Constants.Perpage;
            var header = new HeaderViewModel
            {
                HeadTitle = cate.Title,
                Title = title,
                Description = cate.Description,
                CategoryId = cate.CateId,
                Controller = controller,
                Slug = slug
            };
            var paging = new PagingModel
            {
                CurrentPage = 1,
                PageSize = pageSize,
                TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize)
            };


            var model = new BlogViewModel
            {
                Posts = posts.ToList(),
                Category = cate,
                CateParents = cateParents,
                Header = header,
                Paging = paging,
                Slug = slug,
                IsVideo = IsVideo
            };
            return model;
        }

        public async Task<IEnumerable<Menu>> GetMenuData(string menuType)
        {
            var menuName = configuration.GetValue<string>($"Menu:{menuType}");
            var menus = await postService.GetMenuAsync(menuName);
            return menus;
        }

        public async Task<WorldCupViewModel> GetWorldCupViewModel()
        {
            var lastestNews =  postService.GetPostsBySlugAsync(WorldCup2022.HomepageSlug, Constants.FromFirstItem, Constants.GetFiveItems);
            var commentary =  postService.GetPostsBySlugAsync(WorldCup2022.CommentarySlug, Constants.FromFirstItem, Constants.GetFiveItems);
            var videos =  postService.GetPostsBySlugAsync(WorldCup2022.VideoSlug, Constants.FromFirstItem, Constants.GetTenItems);
            var storyPost =  postService.GetPostsBySlugAsync(WorldCup2022.StoryPostSlug, Constants.FromFirstItem, Constants.GetFourItems, Constants.storyPostType);
            var cate =  postService.GetCateDetailAsync(WorldCup2022.HomepageSlug);

            await Task.WhenAll(lastestNews, commentary, videos, storyPost, cate);
            
            var Model = new WorldCupViewModel
            {
                LastestNews = lastestNews.Result,
                Commentary = commentary.Result,
                Videos = videos.Result,
                StoryPost = storyPost.Result,
                Category = cate.Result,
            };
            return Model;
        }

        public async Task<Euro2024ViewModel> GetEuro2024ViewModel()
        {
            var lastestNews = await postService.GetPostsBySlugAsync(Euro2024.HomepageSlug, Constants.FromFirstItem, Constants.GetTwelveItems);
            var commentary = await postService.GetPostsBySlugAsync(Euro2024.CommentarySlug, Constants.FromFirstItem, Constants.GetTwelveItems);
            var videos = await postService.GetPostsBySlugAsync(Euro2024.VideoSlug, Constants.FromFirstItem, Constants.GetTenItems);
            
            var Model = new Euro2024ViewModel
            {
                LastestNews = lastestNews,
                Commentary = commentary,
                Videos = videos
            };
            return Model;
        }

        public async Task<IList<Match>> GetTodayMatches()
        {
            return await matchService.GetTodayMatchesAsync();
        }

        public async Task<List<MatchLeagueModel>> GetHomepageFixture()
        {
            var option = await optionService.GetOptionAsync(OptionKey.HompageFixture);
            var leagues = Helper.ParseJsonToList<FixtureHomepage>(option?.OptionValue);
            var result = new List<MatchLeagueModel>();
            foreach (var item in leagues)
            {
                var criteria = new GetMatchBySeasonCriteria
                {
                    LeagueId = item.LeagueId,
                    SeasonId = item.SeasonId
                };
                if (item.SeasonId == 0)
                {
                    var currentDate = DateTimeUtilize.UtcNow().DateTime;
                    const byte TotalMonths = 1;
                    criteria.FromTime = currentDate.AddMonths(-TotalMonths).ToStartOfDay();
                    criteria.ToTime = currentDate.AddMonths(TotalMonths).ToEndOfDay();
                }
                var (league, matches) = await matchService.GetMatchBySeasonAsync(criteria);
                var preMatches = matches.Where(item => item.Status != MatchConstants.Finished && item.StartTime.Date >= DateTimeUtilize.UtcNow().Date).Take(20);
                var postMatches = matches.Where(item => item.Status == MatchConstants.Finished || item.Status == MatchConstants.CutInHalf).OrderByDescending(item => item.StartTime).Take(20);
                result.Add(new MatchLeagueModel { League = league, Matches = preMatches.Concat(postMatches).ToList() });
            }
            return result;
        }

        public async Task<List<StandingLeagueModel>> GetHomepageStanding()
        {
            var option = await optionService.GetOptionAsync(OptionKey.HompageStanding);
            var leagues = Helper.ParseJsonToList<FixtureHomepage>(option?.OptionValue);
            var result = new List<StandingLeagueModel>();
            foreach (var item in leagues)
            {
                var (league, standing) = await leagueService.GetLeagueAndSeasonStandingAsync(new GetLeagueAndSeasonStandingsCriteria { LeagueId = item.LeagueId, SeasonId = item.SeasonId });
                result.Add(new StandingLeagueModel { League = league, Standing = standing });
            }
            return result;
        }

        public async Task<(List<FootballNewsHomePage> ,List<IEnumerable<Post>>)> GetFootballNews()
        {
            var option = await optionService.GetOptionAsync(OptionKey.FootballNewsCategories);
            var footballNewsCategories = Helper.ParseJsonToList<FootballNewsHomePage>(option?.OptionValue);
            List<IEnumerable<Post>> leaguePosts = new()
            {
                await postService.GetPostsBySlugAsync(footballNewsCategories[0]?.Slug, Constants.FromFirstItem, Constants.GetEightItems),
                await postService.GetPostsBySlugAsync(footballNewsCategories[1]?.Slug, Constants.FromFirstItem, Constants.GetEightItems),
                await postService.GetPostsBySlugAsync(footballNewsCategories[2]?.Slug, Constants.FromFirstItem, Constants.GetEightItems)
            };
            return (footballNewsCategories, leaguePosts);
        }
    }
}