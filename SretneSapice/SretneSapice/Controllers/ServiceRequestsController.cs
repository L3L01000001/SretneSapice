using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model;
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

        [HttpPost("{serviceRequestId}/enable-live-location")]
        public async Task<IActionResult> EnableLiveLocation(int serviceRequest)
        {
            try
            {
                bool isScheduledServiceTime = await _serviceRequestService.IsScheduledServiceTime(serviceRequest);
                if (!isScheduledServiceTime)
                {
                    return BadRequest("It's not currently scheduled service time.");
                }

                await _serviceRequestService.UpdateLiveLocationEnabled(serviceRequest, true);
                return Ok("Live location enabled.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Failed to enable live location: {ex.Message}");
            }
        }

        [HttpPost("{serviceRequestId}/disable-live-location")]
        public async Task<IActionResult> DisableLiveLocation(int serviceRequest)
        {
            try
            {
                await _serviceRequestService.UpdateLiveLocationEnabled(serviceRequest, false);
                return Ok("Live location disabled.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Failed to disable live location: {ex.Message}");
            }
        }

        [HttpGet("serviceRequests/{dogWalkerId}")]
        public async Task<ActionResult<PagedResult<ServiceRequestDto>>> GetServiceRequestsByWalkerId(int dogWalkerId)
        {
            var serviceRequests = await _serviceRequestService.GetServiceRequestsByWalkerId(dogWalkerId);
            return Ok(serviceRequests);
        }

        [HttpGet("serviceRequestsByLoggedInUser")]
        public async Task<IActionResult> GetServiceRequestsByLoggedInUser()
        {
            var serviceRequests = await _serviceRequestService.GetServiceRequestsByLoggedInUser();
            if (serviceRequests == null || serviceRequests.Result.Count == 0)
            {
                return NotFound();
            }
            return Ok(serviceRequests);
        }
    }
}
