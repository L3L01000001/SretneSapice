using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using SretneSapice.Services;
using Microsoft.AspNetCore.Authorization;
using SretneSapice.Model;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ForumPostsController : BaseCRUDController<ForumPostDto, ForumPostSearchObject, ForumPostInsertRequest, ForumPostUpdateRequest>
    {
        private readonly IForumPostService _forumPostService;
        public ForumPostsController(IForumPostService service, ILogger<BaseController<ForumPostDto, ForumPostSearchObject>> logger) : base(logger, service)
        {
            _forumPostService = service;
        }

    }
}
