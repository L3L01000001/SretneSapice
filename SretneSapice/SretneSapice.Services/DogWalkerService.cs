using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model;
using SretneSapice.Model.Constants;
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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace SretneSapice.Services
{
    public class DogWalkerService : BaseCRUDService<DogWalkerDto, DogWalker, DogWalkerSearchObject, DogWalkerInsertRequest, DogWalkerInsertRequest>, IDogWalkerService
    {
        public BaseState _baseState { get; set; }
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public DogWalkerService(BaseState baseState, _180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _baseState = baseState;
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public override IQueryable<DogWalker> AddInclude(IQueryable<DogWalker> query, DogWalkerSearchObject? search = null)
        {
            query = query.Include(x => x.ServiceRequests)
                         .Include(x => x.City);
            return base.AddInclude(query, search);
        }

        public override Task<DogWalkerDto> Insert(DogWalkerInsertRequest insertRequest)
        {
            var state = _baseState.CreateState("Pending");

            return state.Insert(insertRequest);
        }

        public async Task<DogWalkerDto> Approve(int dogWalkerId)
        {
            var entity = await _context.DogWalkers.FindAsync(dogWalkerId);

            var state = _baseState.CreateState("Approved");
            state.CurrentEntity = entity;

            await state.Approve();

            var dogWalkerRoleForApproved = new UserRole
            {
                UserId = entity.UserId,
                RoleId = 3,
                DateOfChange = DateTime.Now
            };

            await _context.AddAsync(dogWalkerRoleForApproved);
            await _context.SaveChangesAsync();

            return await GetById(dogWalkerId);
        }

        public async Task<DogWalkerDto> Reject(int dogWalkerId)
        {
            var entity = await _context.DogWalkers.FindAsync(dogWalkerId);

            var state = _baseState.CreateState("Rejected");
            state.CurrentEntity = entity;

            await state.Reject();

            var userRole = await _context.UserRoles
                                         .FirstOrDefaultAsync(ur => ur.UserId == entity.UserId && ur.RoleId == 3); 

            if (userRole != null)
            {
                _context.UserRoles.Remove(userRole);
            }

            await _context.SaveChangesAsync();

            return await GetById(dogWalkerId);
        }

        public async Task<DogWalkerDto> CancelApplication(int dogWalkerId)
        {
            var entity = await _context.DogWalkers.FindAsync(dogWalkerId);

            var state = _baseState.CreateState("Cancelled");
            state.CurrentEntity = entity;

            await state.CancelApplication();
            return await GetById(dogWalkerId);
        }

        public async Task<List<string>> AllowedActions(int dogWalkerId)
        {
            var entity = await _context.DogWalkers.FindAsync(dogWalkerId);
            var state = _baseState.CreateState(entity?.Status ?? throw new InvalidOperationException());
            return state.AllowedActions();
        }

        public override IQueryable<DogWalker> AddFilter(IQueryable<DogWalker> query, DogWalkerSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FullName))
            {
                var fullNameParts = search.FullName.Split(' ', 2);
                var firstName = fullNameParts[0];
                var lastName = fullNameParts.Length > 1 ? fullNameParts[1] : string.Empty;

                filteredQuery = filteredQuery.Where(x => x.Name.Contains(firstName) || x.Surname.Contains(lastName));
            }

            if(search?.Rating > 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Rating == search.Rating);
            }

            if(search?.BestRating == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Rating == 5);
            }

            if (search?.CityId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.CityId == search.CityId);
            }

            if(search?.isApproved == true)
            {
                filteredQuery = filteredQuery.Where(x => x.IsApproved == true);
            }

            if(search?.Top5 == true)
            {
                filteredQuery = filteredQuery.OrderByDescending(x => x.ServiceRequests.Count()).Take(5);
            }

            return filteredQuery;
        }

        public int CalculateFinishedServiceRequests(int dogWalkerId)
        {
            var dogWalkerServices = _context.ServiceRequests
                                  .Where(r => r.DogWalkerId == dogWalkerId)
                                  .ToList();

            if (dogWalkerServices != null)
            {
                int numberOfFinishedServiceRequests = dogWalkerServices.Count(sr => sr.Status == "Finished");

                return numberOfFinishedServiceRequests;
            }
            else
            {
                return 0;
            }
        }

        public async Task<PagedResult<DogWalkerDto>> GetDogWalkersWithMostReviewsFirst()
        {
            var dogWalkersWithReviews = _context.DogWalkers
                                            .Include(dw => dw.WalkerReviews).AsQueryable();

            var mostReviewsFirst = dogWalkersWithReviews.OrderByDescending(dw => dw.WalkerReviews.Count);

            PagedResult<DogWalkerDto> result = new PagedResult<DogWalkerDto>();

            result.Count = await mostReviewsFirst.CountAsync();

            var dogwalkers = await mostReviewsFirst.ToListAsync();

            result.Result = _mapper.Map<List<DogWalkerDto>>(dogwalkers);

            return result;
        }

        public async Task<PagedResult<DogWalkerDto>> GetDogWalkersWithMostFinishedServicesFirst()
        {
            var dogWalkersWithReviews =  _context.DogWalkers
                                            .Include(dw => dw.ServiceRequests)
                                            .AsQueryable();

            var mostFinishedServicesFirst = dogWalkersWithReviews.OrderByDescending(dw => dw.ServiceRequests.Count(sr => sr.Status == "Finished"));

            PagedResult<DogWalkerDto> result = new PagedResult<DogWalkerDto>();

            result.Count = await mostFinishedServicesFirst.CountAsync();

            var dogwalkers = await mostFinishedServicesFirst.ToListAsync();

            result.Result = _mapper.Map<List<DogWalkerDto>>(dogwalkers);

            return result;
        }

        public async Task<bool> HasUserAppliedToBeDogWalker(int userId)
        {
            return await _context.DogWalkers.AnyAsync(dw => dw.UserId == userId);
        }

        public async Task<string> GetDogWalkerStatusByUserId(int userId)
        {
            var dogWalker = _context.DogWalkers.FirstOrDefault(dw => dw.UserId == userId);
            return dogWalker?.Status ?? "Unknown";
        }

        public override async Task<DogWalkerDto> GetById(int id)
        {
            var entity = await _context.Set<DogWalker>()
                .Include(x => x.WalkerReviews)
                .Include(x => x.ServiceRequests)
                .Include(x => x.City)
                .FirstOrDefaultAsync(fp => fp.DogWalkerId == id);

            if (entity == null)
            {
                throw new Exception("Dog walker not found!");
            }

            return _mapper.Map<DogWalkerDto>(entity);
        }

        public async Task<int> GetDogWalkerIdByUserId(int userId)
        {
            var dogWalker = await _context.DogWalkers.FirstOrDefaultAsync(dw => dw.UserId == userId);
            return dogWalker?.DogWalkerId ?? 0;
        }
    }
}
