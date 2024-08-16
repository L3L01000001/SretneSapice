using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class ProductsController : BaseCRUDController<ProductDto, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {
        private readonly IProductService _productService;
        public ProductsController(IProductService service, ILogger<BaseController<ProductDto, ProductSearchObject>> logger) : base(logger, service)
        {
            _productService = service;
        }

        [HttpGet("Recommend/{id}")]
        public virtual List<ProductDto> Recommend(int id)
        {
            return ((IProductService)_service).Recommend(id);
        }
    }
}