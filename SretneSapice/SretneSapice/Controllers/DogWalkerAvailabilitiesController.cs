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
    public class DogWalkerAvailabilitiesController : BaseCRUDController<DogWalkerAvailabilityDto, BaseSearchObject, DogWalkerAvailabilityInsertRequest, DogWalkerAvailabilityInsertRequest>
    {
        private readonly IDogWalkerAvailabilityService _dogWalkerAvailabilityService;
        public DogWalkerAvailabilitiesController(IDogWalkerAvailabilityService service, ILogger<BaseController<DogWalkerAvailabilityDto, BaseSearchObject>> logger) : base(logger, service)
        {
            _dogWalkerAvailabilityService = service;
        }

        [HttpGet("getAvailabilityStatusForDogWalker/{dogWalkerId}")]
        public async Task<ActionResult<PagedResult<DogWalkerAvailabilityDto>>> GetAvailabilitiesByWalkerId(int dogWalkerId)
        {
            var availabilites = await _dogWalkerAvailabilityService.GetAvailabilitiesByWalkerId(dogWalkerId);

            return Ok(availabilites);
        }
    }
}
