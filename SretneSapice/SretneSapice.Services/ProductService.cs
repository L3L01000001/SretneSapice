using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace SretneSapice.Services
{
    public class ProductService : BaseCRUDService<ProductDto, Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>, IProductService
    {
        public ProductService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Product entity, ProductInsertRequest insert)
        {
            entity.CreatedDate = DateTime.Now;
        }

        public override IQueryable<Product> AddInclude(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            query = query.Include(x => x.ProductType);
            return base.AddInclude(query, search);
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return base.AddFilter(query, search);
        }

        public async Task<PagedResult<ProductDto>> GetProductsByPriceLowToHighAsync()
        {

            var query = _context.Products.OrderBy(p => p.Price).AsQueryable();

            PagedResult<ProductDto> result = new PagedResult<ProductDto>();

            result.Count = await query.CountAsync();

            var products = await query.ToListAsync();

            result.Result = _mapper.Map<List<ProductDto>>(products);

            return result;
        }

        public async Task<PagedResult<ProductDto>> GetProductsByPriceHighToLowAsync()
        {
            var query = _context.Products.OrderByDescending(p => p.Price).AsQueryable();

            PagedResult<ProductDto> result = new PagedResult<ProductDto>();

            result.Count = await query.CountAsync();

            var products = await query.ToListAsync();

            result.Result = _mapper.Map<List<ProductDto>>(products);

            return result;
        }

        public async Task<PagedResult<ProductDto>> GetNewestProductsAsync()
        {
            var query =  _context.Products.OrderByDescending(p => p.CreatedDate).AsQueryable();

            PagedResult<ProductDto> result = new PagedResult<ProductDto>();

            result.Count = await query.CountAsync();

            var products = await query.ToListAsync();

            result.Result = _mapper.Map<List<ProductDto>>(products);

            return result;
        }

    }
}
