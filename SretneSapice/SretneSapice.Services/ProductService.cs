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

        //public override async Task<List<ProductDto>> GetAll(ProductSearchObject search)
        //{
        //    var query = _context.Set<Product>().AsQueryable();

        //    if(!string.IsNullOrWhiteSpace(search?.Name))
        //    {
        //        query = query.Where( x => x.Name.StartsWith(search.Name));
        //    }

        //    var list = await query.ToListAsync();

        //    return _mapper.Map<List<ProductDto>>(list);
        //}

        public override IQueryable<Product> AddFilter(IQueryable<Product> query, ProductSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.StartsWith(search.Name));
            }

            return base.AddFilter(query, search);
        }

    }
}
