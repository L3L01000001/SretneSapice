using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TagsController : BaseCRUDController<TagDto, TagSearchObject, TagInsertRequest, TagInsertRequest>
    {
        public TagsController(ITagService service, ILogger<BaseController<TagDto, TagSearchObject>> logger ) : base(logger, service)
        {
        }
    }
}
