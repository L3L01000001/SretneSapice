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
    public class CityService : BaseService<CityDto, City, BaseSearchObject>, ICityService
    {
        public CityService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<City> AddInclude(IQueryable<City> query, BaseSearchObject? search = null)
        {
            query = query.Include(x => x.Country);
            return base.AddInclude(query, search);
        }

        public override async Task<CityDto> GetById(int id)
        {
            var entity = await _context.Cities.Include(x => x.Country).FirstOrDefaultAsync(x => x.CityId == id);
            return _mapper.Map<CityDto>(entity);

        }
    }
}
