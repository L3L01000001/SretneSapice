using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class DogWalkerLocationService : BaseCRUDService<DogWalkerLocationDto, DogWalkerLocation, BaseSearchObject, DogWalkerLocationInsertRequest, DogWalkerLocationInsertRequest>, IDogWalkerLocationService
    {
        public DogWalkerLocationService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<bool> DogWalkerExistsInTable(int dogWalkerId)
        {
            return await _context.DogWalkerLocations.AnyAsync(dw => dw.DogWalkerId == dogWalkerId);
        }
    }
}
