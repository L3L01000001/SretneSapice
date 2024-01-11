using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductsController : BaseCRUDController<ProductDto, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {
        public ProductsController(IProductService service, ILogger<BaseController<ProductDto, ProductSearchObject>> logger) : base(logger, service)
        {
        }
    }
}