using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using SretneSapice.Model;
using SretneSapice.Model.Constants;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using SretneSapice.Services.RabbitMQ;
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
        private readonly IMailProducer _mailProducer;
        public ServiceRequestService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor, IMailProducer mailProducer) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            _mailProducer = mailProducer;
        }

        public override IQueryable<ServiceRequest> AddInclude(IQueryable<ServiceRequest> query, BaseSearchObject? search = null)
        {
            query = query.Include(x => x.User).Include(x => x.DogWalker);
            return base.AddInclude(query, search);
        }

        public override async Task<ServiceRequestDto> Insert(ServiceRequestInsertRequest insertRequest)
        {
            if(insertRequest.DogWalkerId == LoggedInUserId)
            {
                throw new Exception("You cannot request services from yourself.");
            }

            insertRequest.UserId = LoggedInUserId;

            var serviceRequestEntity = _mapper.Map<ServiceRequest>(insertRequest);

            serviceRequestEntity.Status = "Pending";

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

        public async Task<bool> IsScheduledServiceTime(int serviceId)
        {
            var service = await _context.ScheduledServices.FindAsync(serviceId);
            if (service == null)
            {
                return false;
            }

            DateTime currentTime = DateTime.Now;
            return currentTime >= service.StartTime && currentTime <= service.EndTime;
        }

        public async Task UpdateLiveLocationEnabled(int serviceId, bool enableLiveLocation)
        {
            var service = await _context.ServiceRequests.FindAsync(serviceId);
            if (service == null)
            {
                throw new Exception("Service request not found");
            }

            service.LiveLocationEnabled = enableLiveLocation;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
               throw new Exception("Failed to update live location status.");
            }
        }

        public async Task AcceptServiceRequest(int serviceRequestId)
        {
            var serviceRequest = await _context.ServiceRequests.FindAsync(serviceRequestId);
            if (serviceRequest == null)
            {
                throw new InvalidOperationException("Service request not found");
            }

            serviceRequest.Status = "Accepted";

            if (serviceRequest.Date == null || serviceRequest.StartTime == null || serviceRequest.EndTime == null)
            {
                throw new InvalidOperationException("Service request does not have valid date or time information");
            }

            if (serviceRequest.DogWalkerId == null)
            {
                throw new InvalidOperationException("DogWalkerId is null in the service request.");
            }

            var availability = await _context.DogWalkerAvailabilities
                .FirstOrDefaultAsync(a => a.DogWalkerId == serviceRequest.DogWalkerId &&
                                          a.Date == serviceRequest.Date &&
                                          a.StartTime == serviceRequest.StartTime &&
                                          a.EndTime == serviceRequest.EndTime);

            if (availability == null)
            {
                availability = new DogWalkerAvailability
                {
                    DogWalkerId = serviceRequest.DogWalkerId ?? 0,
                    Date = serviceRequest.Date.Value,
                    StartTime = serviceRequest.StartTime,
                    EndTime = serviceRequest.EndTime,
                    AvailabilityStatus = "Scheduled"
                };
                await _context.DogWalkerAvailabilities.AddAsync(availability);
            }
            else
            {
                availability.AvailabilityStatus = "Scheduled";
            }

            await _context.SaveChangesAsync();

            var user = await _context.Users.FindAsync(serviceRequest.UserId);
            if (user != null)
            {
                var emailMessage = new
                {
                    Sender = "sretnesapice@outlook.com",
                    Recipient = user.Email,
                    Subject = "Prihvaćen termin i usluga od šetača!",
                    Content = $"Zakazani termin za {serviceRequest.Date.Value.ToShortDateString()} je prihvaćen od strane šetača za pasminu {serviceRequest.DogBreed}. Lokacija će Vam biti omogućena u trenutku obavljanja usluge."
                };

                _mailProducer.SendEmail(emailMessage);
            }
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

        public async Task<PagedResult<ServiceRequestDto>> GetServiceRequestsByWalkerId(int dogWalkerId)
        {
            var allServiceRequests = _context.ServiceRequests
                                            .Include(x => x.User).Include(x => x.DogWalker)
                                            .AsQueryable();

            var selected = allServiceRequests.Where(x => x.DogWalkerId == dogWalkerId);

            PagedResult<ServiceRequestDto> result = new PagedResult<ServiceRequestDto>();

            result.Count = await selected.CountAsync();

            var serviceRequests = await selected.ToListAsync();

            result.Result = _mapper.Map<List<ServiceRequestDto>>(serviceRequests);

            return result;
        }

        public async Task<PagedResult<ServiceRequestDto>> GetServiceRequestsByLoggedInUser()
        {
            var now = DateTime.Now;
            var allServiceRequests = _context.ServiceRequests
                .Include(x => x.User)
                .Include(x => x.DogWalker)
                .Where(x => x.UserId == LoggedInUserId && x.Status == "Accepted" && x.StartTime <= now && x.EndTime >= now)
                .AsQueryable();

            PagedResult<ServiceRequestDto> result = new PagedResult<ServiceRequestDto>
            {
                Count = await allServiceRequests.CountAsync(),
                Result = _mapper.Map<List<ServiceRequestDto>>(await allServiceRequests.ToListAsync())
            };

            return result;
        }
    }
}
