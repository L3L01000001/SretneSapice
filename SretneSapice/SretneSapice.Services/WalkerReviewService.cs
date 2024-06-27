using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
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

namespace SretneSapice.Services
{
    public class WalkerReviewService : BaseCRUDService<WalkerReviewDto, WalkerReview, BaseSearchObject, WalkerReviewInsertRequest, WalkerReviewInsertRequest>, IWalkerReviewService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IDogWalkerService _dogWalkerService;
        public WalkerReviewService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor, IDogWalkerService dogWalkerService) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            _dogWalkerService = dogWalkerService;
        }

        public override IQueryable<WalkerReview> AddInclude(IQueryable<WalkerReview> query, BaseSearchObject? search = null)
        {
            query = query.Include(x => x.User).Include(x => x.DogWalker);
            return base.AddInclude(query, search);
        }

        public async Task UpdateDogWalkerRating(int dogWalkerId)
        {
            var reviews = await _context.WalkerReviews
                                          .Where(r => r.DogWalkerId == dogWalkerId)
                                          .ToListAsync();

            if (reviews.Any())
            {
                int sumOfRatings = reviews.Sum(r => r.Rating);
                int numberOfReviews = reviews.Count();
                int averageRating = numberOfReviews > 0 ? sumOfRatings / numberOfReviews : 0;

                var dogWalker = await _context.DogWalkers.FindAsync(dogWalkerId);
                if (dogWalker != null)
                {
                    dogWalker.Rating = averageRating;
                    await _context.SaveChangesAsync();
                }
            }
        }

        public override async Task<WalkerReviewDto> Insert(WalkerReviewInsertRequest insertRequest)
        {
            var dogWalker = await _context.DogWalkers.FindAsync(insertRequest.DogWalkerId);
            if (dogWalker == null)
            {
                throw new Exception("Dog Walker not found.");
            }

            if (dogWalker.UserId == LoggedInUserId)
            {
                throw new Exception("You cannot give yourself a review.");
            }

            insertRequest.UserId = LoggedInUserId;
            insertRequest.Timestamp = DateTime.Now;

            var walkerReviewEntity = _mapper.Map<WalkerReview>(insertRequest);

            await _context.WalkerReviews.AddAsync(walkerReviewEntity);

            await _context.SaveChangesAsync();

            await UpdateDogWalkerRating(insertRequest.DogWalkerId);

            return _mapper.Map<WalkerReviewDto>(walkerReviewEntity);
        }
    }
}
