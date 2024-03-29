﻿using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
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
            query = query.Include(x => x.ServiceRequests);
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

        public async Task<List<DogWalkerDto>> GetDogWalkersWithMostReviewsFirst()
        {
            var dogWalkersWithReviews = await _context.DogWalkers
                                            .Include(dw => dw.WalkerReviews)
                                            .ToListAsync();

            var mostReviewsFirst = dogWalkersWithReviews.OrderByDescending(dw => dw.WalkerReviews.Count);

            return _mapper.Map<List<DogWalkerDto>>(mostReviewsFirst);
        }

        public async Task<List<DogWalkerDto>> GetDogWalkersWithMostFinishedServicesFirst()
        {
            var dogWalkersWithReviews = await _context.DogWalkers
                                            .Include(dw => dw.ServiceRequests)
                                            .ToListAsync();

            var mostFinishedServicesFirst = dogWalkersWithReviews.OrderByDescending(dw => dw.ServiceRequests.Count(sr => sr.Status == "Finished"));

            return _mapper.Map<List<DogWalkerDto>>(mostFinishedServicesFirst);
        }
    }
}
