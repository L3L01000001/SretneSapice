using AutoMapper;
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
    public class CityService : BaseService<CityDto, City, BaseSearchObject>, ICityService
    {
        public CityService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
