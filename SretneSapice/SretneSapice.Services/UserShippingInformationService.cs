using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Constants;
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
    public class UserShippingInformationService : BaseCRUDService<UserShippingInformationDto, UserShippingInformation, BaseSearchObject, UserShippingInformationInsertRequest, UserShippingInformationInsertRequest>, IUserShippingInformationService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public UserShippingInformationService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }


        public override async Task<UserShippingInformationDto> Insert(UserShippingInformationInsertRequest insertRequest)
        {
            var userShippingInfoEntity = _mapper.Map<UserShippingInformation>(insertRequest);

            userShippingInfoEntity.UserId = LoggedInUserId;

            await _context.UserShippingInformations.AddAsync(userShippingInfoEntity);

            await _context.SaveChangesAsync();

            var userOrder = await _context.Orders.FirstOrDefaultAsync(x => x.UserId == LoggedInUserId && x.Status == OrderStatuses.InCart);

            userOrder.ShippingInfoId = userShippingInfoEntity.ShippingInfoId;

            await _context.SaveChangesAsync();

            return _mapper.Map<UserShippingInformationDto>(userShippingInfoEntity);
        }
    }
}
