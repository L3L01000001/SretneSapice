using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ServiceRequestsController : BaseCRUDController<ServiceRequestDto, BaseSearchObject, ServiceRequestInsertRequest, ServiceRequestInsertRequest>
    {
        private readonly IServiceRequestService _serviceRequestService;
        public ServiceRequestsController(IServiceRequestService service, ILogger<BaseController<ServiceRequestDto, BaseSearchObject>> logger) : base(logger, service)
        {
            _serviceRequestService = service;
        }

        [HttpPut("{serviceRequestId}/accept")]
        public async Task AcceptServiceRequest(int serviceRequestId)
        {
            await _serviceRequestService.AcceptServiceRequest(serviceRequestId);
        }

        [HttpPut("{serviceRequestId}/reject")]
        public async Task RejectServiceRequest(int serviceRequestId)
        {
            await _serviceRequestService.RejectServiceRequest(serviceRequestId);
        }

        [HttpPut("{serviceRequestId}/markAsFinished")]
        public async Task FinishServiceRequest(int serviceRequestId)
        {
            await _serviceRequestService.FinishServiceRequest(serviceRequestId);
        }
    }
}
