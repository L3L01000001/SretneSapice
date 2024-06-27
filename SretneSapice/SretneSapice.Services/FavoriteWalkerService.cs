using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using SretneSapice.Services.DogWalkerStatusStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class FavoriteWalkerService : BaseCRUDService<FavoriteWalkerDto, FavoriteWalker, FavoriteDogWalkerSearchObject, FavoriteWalkerInsertRequest, FavoriteWalkerInsertRequest>, IFavoriteWalkerService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public FavoriteWalkerService( _180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public override IQueryable<FavoriteWalker> AddInclude(IQueryable<FavoriteWalker> query, FavoriteDogWalkerSearchObject? search = null)
        {
            query = query.Include(x => x.User).Include(x => x.DogWalker);
            return base.AddInclude(query, search);
        }


        public override IQueryable<FavoriteWalker> AddFilter(IQueryable<FavoriteWalker> query, FavoriteDogWalkerSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);


            if (search?.UserId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }

            return filteredQuery;
        }

        public override async Task<FavoriteWalkerDto> Insert(FavoriteWalkerInsertRequest insertRequest)
        {
            var favoriteWalkerEntity = _mapper.Map<FavoriteWalker>(insertRequest);

            favoriteWalkerEntity.UserId = (int?)LoggedInUserId;

            await _context.FavoriteWalkers.AddAsync(favoriteWalkerEntity);
            await _context.SaveChangesAsync();

            return _mapper.Map<FavoriteWalkerDto>(favoriteWalkerEntity);
        }

        public int FavoriteWalkersTotalByUserId()
        {
            var favoriteWalkers = _context.FavoriteWalkers
                                  .Where(r => r.UserId == (int?)LoggedInUserId)
                                  .ToList();

            if (favoriteWalkers != null)
            {
                int numberOfFavoriteWalkers = favoriteWalkers.Count();

                return numberOfFavoriteWalkers;
            }
            else
            {
                return 0;
            }
        }
    }
}
