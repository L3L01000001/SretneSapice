using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class ProductTypeService : BaseService<ProductTypeDto, ProductType, BaseSearchObject>, IProductTypeService
    {
        public ProductTypeService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
