﻿using SretneSapice.Model;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IProductService : ICRUDService<ProductDto, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest>
    {
        List<ProductDto> Recommend(int id);
    }
}
