using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CommentsController : BaseCRUDController<CommentDto, BaseSearchObject, CommentInsertRequest, CommentUpdateRequest>
    {
        public CommentsController(ICommentService service, ILogger<BaseController<CommentDto, BaseSearchObject>> logger) : base(logger, service)
        {
        }
    }
}
