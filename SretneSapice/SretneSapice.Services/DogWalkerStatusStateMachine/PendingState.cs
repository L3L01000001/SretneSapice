using AutoMapper;
using Microsoft.AspNetCore.Http;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.DogWalkerStatusStateMachine
{
    public class PendingState : BaseState
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public PendingState(IServiceProvider serviceProvider, _180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(serviceProvider, context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public override async Task<DogWalkerDto> Insert(DogWalkerInsertRequest request)
        {
            var set = _context.Set<DogWalker>();

            var entity = _mapper.Map<DogWalker>(request);

            entity.Status = "Pending";
            entity.UserId = (int?)LoggedInUserId;
            entity.IsApproved = false;
            entity.Rating = 0;

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<DogWalkerDto>(entity);
        }
    }
}
