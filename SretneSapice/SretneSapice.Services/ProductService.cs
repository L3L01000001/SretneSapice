using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class ProductService : BaseCRUDService<ProductDto, Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>, IProductService
    {
        public ProductService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return base.AddFilter(query, search);
        }

        public async Task<List<ProductDto>> GetProductsByPriceLowToHighAsync()
        {
            var products = await _context.Products.OrderBy(p => p.Price).ToListAsync();
            return _mapper.Map<List<ProductDto>>(products);
        }

        public async Task<List<ProductDto>> GetProductsByPriceHighToLowAsync()
        {
            var products = await _context.Products.OrderByDescending(p => p.Price).ToListAsync();
            return _mapper.Map<List<ProductDto>>(products);
        }

        public async Task<List<ProductDto>> GetNewestProductsAsync()
        {
            var products = await _context.Products.OrderByDescending(p => p.CreatedDate).ToListAsync();
            return _mapper.Map<List<ProductDto>>(products);
        }

    }
}
