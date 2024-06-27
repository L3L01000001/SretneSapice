using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace SretneSapice.Services
{
    public class DogWalkerAvailabilityService : BaseCRUDService<DogWalkerAvailabilityDto, DogWalkerAvailability, BaseSearchObject, DogWalkerAvailabilityInsertRequest, DogWalkerAvailabilityInsertRequest>, IDogWalkerAvailabilityService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public DogWalkerAvailabilityService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public async Task<PagedResult<DogWalkerAvailabilityDto>> GetAvailabilitiesByWalkerId(int walkerId)
        {
            var query = _context.DogWalkerAvailabilities
                .Where(a => a.DogWalkerId == walkerId)
                .AsQueryable();

            var result = new PagedResult<DogWalkerAvailabilityDto>();

            result.Count = await query.CountAsync();

            var availabilities = await query.ToListAsync();

            result.Result = _mapper.Map<List<DogWalkerAvailabilityDto>>(availabilities);

            return result;
        }
    }
}
