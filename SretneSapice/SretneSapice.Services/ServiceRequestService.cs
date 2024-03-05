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

namespace SretneSapice.Services
{
    public class ServiceRequestService : BaseCRUDService<ServiceRequestDto, ServiceRequest, BaseSearchObject, ServiceRequestInsertRequest, ServiceRequestInsertRequest>, IServiceRequestService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ServiceRequestService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public override IQueryable<ServiceRequest> AddInclude(IQueryable<ServiceRequest> query, BaseSearchObject? search = null)
        {
            query = query.Include(x => x.User).Include(x => x.DogWalker);
            return base.AddInclude(query, search);
        }

        public override async Task<ServiceRequestDto> Insert(ServiceRequestInsertRequest insertRequest)
        {
            var dogWalker = await _context.ServiceRequests.FirstOrDefaultAsync(s => s.DogWalkerId == insertRequest.DogWalkerId);

            if(insertRequest.DogWalkerId == LoggedInUserId)
            {
                throw new Exception("You cannot request services from yourself.");
            }

            if (dogWalker == null)
            {
                throw new Exception("Dog walker not found");
            }

            insertRequest.UserId = LoggedInUserId;
            insertRequest.Status = "Pending";

            var serviceRequestEntity = _mapper.Map<ServiceRequest>(insertRequest);

            await _context.ServiceRequests.AddAsync(serviceRequestEntity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ServiceRequestDto>(serviceRequestEntity);
        }

        public override async Task<ServiceRequestDto> HardDelete(int id)
        {
            var serviceRequest = await _context.ServiceRequests.FirstOrDefaultAsync(s => s.ServiceRequestId == id);

            var deletedItem = await base.HardDelete(id);

            return deletedItem;
        }

        public async Task AcceptServiceRequest(int serviceRequestId)
        {
            var serviceRequest = await _context.ServiceRequests.FindAsync(serviceRequestId);
            if (serviceRequest == null)
            {
                throw new InvalidOperationException("Service request not found");
            }

            serviceRequest.Status = "Accepted";

            await _context.SaveChangesAsync();
        }

        public async Task RejectServiceRequest(int serviceRequestId)
        {
            var serviceRequest = await _context.ServiceRequests.FindAsync(serviceRequestId);
            if (serviceRequest == null)
            {
                throw new InvalidOperationException("Service request not found");
            }

            serviceRequest.Status = "Rejected";

            await _context.SaveChangesAsync();
        }

        public async Task FinishServiceRequest(int serviceRequestId)
        {
            var serviceRequest = await _context.ServiceRequests.FindAsync(serviceRequestId);
            if (serviceRequest == null)
            {
                throw new InvalidOperationException("Service request not found");
            }

            serviceRequest.Status = "Finished";

            await _context.SaveChangesAsync();
        }
    }
}
