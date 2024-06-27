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
    public class DogWalkerLocationsController : BaseCRUDController<DogWalkerLocationDto, BaseSearchObject, DogWalkerLocationInsertRequest, DogWalkerLocationInsertRequest>
    {
        private readonly IDogWalkerLocationService _dogWalkerLocationService;
        public DogWalkerLocationsController(IDogWalkerLocationService service, ILogger<BaseController<DogWalkerLocationDto, BaseSearchObject>> logger) : base(logger, service)
        {
            _dogWalkerLocationService = service;
        }

        [HttpGet("dogWalkerExistsInTable/{dogWalkerId}")]
        public async Task<IActionResult> DogWalkerExistsInTable(int dogWalkerId)
        {
            var hasApplied = await _dogWalkerLocationService.DogWalkerExistsInTable(dogWalkerId);
            return Ok(hasApplied);
        }
    }
}
