using SretneSapice.Model.Dtos;
using SretneSapice.Services.Database;
using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SretneSapice.Model.Requests;

namespace SretneSapice.Services.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<User, UserDto>();
            CreateMap<UserInsertRequest, User>();
            CreateMap<UserUpdateRequest, User>();

            CreateMap<ProductType, ProductTypeDto>();

            CreateMap<Product, ProductDto>();
            CreateMap<ProductInsertRequest, Product>();
            CreateMap<ProductUpdateRequest, Product>(); 

            CreateMap<UserRole, UserRoleDto>();

            CreateMap<Role, RoleDto>();

            CreateMap<City, CityDto>();
            CreateMap<Country, CountryDto>();
        }
    }
}
