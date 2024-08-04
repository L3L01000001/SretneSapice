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

        [HttpGet("Price-low-to-high")]
        public async Task<ActionResult<PagedResult<ProductDto>>> GetProductsByPriceLowToHigh()
        {
            var products = await _productService.GetProductsByPriceLowToHighAsync();
            return Ok(products);
        }

        [HttpGet("Price-high-to-low")]
        public async Task<ActionResult<PagedResult<ProductDto>>> GetProductsByPriceHighToLow()
        {
            var products = await _productService.GetProductsByPriceHighToLowAsync();
            return Ok(products);
        }

        [HttpGet("Newest")]
        public async Task<ActionResult<PagedResult<ProductDto>>> GetNewestProducts()
        {
            var products = await _productService.GetNewestProductsAsync();
            return Ok(products);
        }

        [HttpGet("Recommend/{id}")]
        public virtual List<ProductDto> Recommend(int id)
        {
            return ((IProductService)_service).Recommend(id);
        }
    }
}