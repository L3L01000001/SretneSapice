using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class ProductTypesController : BaseController<ProductTypeDto, BaseSearchObject>
    {
        public ProductTypesController(ILogger<BaseController<ProductTypeDto, BaseSearchObject>> logger, IProductTypeService service ): base(logger, service)
        {
        }
    }
}
