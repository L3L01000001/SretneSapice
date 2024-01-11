using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class ProductTypesController : BaseController<ProductTypeDto, BaseSearchObject>
    {
        public ProductTypesController(IService<ProductTypeDto, BaseSearchObject> service, ILogger<BaseController<ProductTypeDto, BaseSearchObject>> logger): base(logger, service)
        {
        }
    }
}
