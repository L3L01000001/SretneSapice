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
    public class DogWalkersController : BaseCRUDController<DogWalkerDto, DogWalkerSearchObject, DogWalkerInsertRequest, DogWalkerInsertRequest>
    {
        private readonly IDogWalkerService _dogWalkerService;
        public DogWalkersController(IDogWalkerService service, ILogger<BaseController<DogWalkerDto, DogWalkerSearchObject>> logger) : base(logger, service)
        {
            _dogWalkerService = service;
        }

        [HttpGet("{dogWalkerId}/allowedActions")]
        [Authorize(Roles = "DogWalkerVerifier, User")]
        public virtual async Task<List<string>> AllowedActions(int dogWalkerId)
        {
            return await _dogWalkerService.AllowedActions(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/approve")]
        [Authorize(Roles = "DogWalkerVerifier")]
        public virtual async Task<DogWalkerDto> Approve(int dogWalkerId)
        {
            return await _dogWalkerService.Approve(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/reject")]
        [Authorize(Roles = "DogWalkerVerifier")]
        public virtual async Task<DogWalkerDto> Reject(int dogWalkerId)
        {
            return await _dogWalkerService.Reject(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/cancelApplication")]
        [Authorize(Roles = "User")]
        public virtual async Task<DogWalkerDto> CancelApplication(int dogWalkerId)
        {
            return await _dogWalkerService.CancelApplication(dogWalkerId);
        }

        [HttpGet("{dogWalkerId}/numberOfFinishedServices")]
        public int CalculateFinishedServiceRequests(int dogWalkerId)
        {
            var numberOfFinishedServices = _dogWalkerService.CalculateFinishedServiceRequests(dogWalkerId);

            return numberOfFinishedServices;
        }

        [HttpGet("getDogWalkersWithMostReviewsFirst")]
        public async Task<ActionResult<PagedResult<DogWalkerDto>>> GetDogWalkersWithMostReviewsFirst()
        {
            var dogwalkers =  await _dogWalkerService.GetDogWalkersWithMostReviewsFirst();

            return Ok(dogwalkers);
        }


        [HttpGet("getDogWalkersWithMostFinishedServicesFirst")]
        public async Task<ActionResult<PagedResult<DogWalkerDto>>> GetDogWalkersWithMostFinishedServicesFirst()
        {
            var dogwalkers = await _dogWalkerService.GetDogWalkersWithMostFinishedServicesFirst();
            return Ok(dogwalkers);

        }

        [HttpGet("hasUserAppliedToBeDogWalker/{userId}")]
        public async Task<IActionResult> CheckDogWalkerApplicationStatus(int userId)
        {
            var hasApplied = await _dogWalkerService.HasUserAppliedToBeDogWalker(userId);
            return Ok(hasApplied);
        }

        [HttpGet("getDogWalkerStatusByUserId/{userId}")]
        public IActionResult GetDogWalkerStatusByUserId(int userId)
        {
            var status = _dogWalkerService.GetDogWalkerStatusByUserId(userId);
            return Ok(status);
        }

        [HttpGet("getDogWalkerIdByUserId/{userId}")]
        public async Task<IActionResult> GetDogWalkerIdByUserId(int userId)
        {
            var id = await _dogWalkerService.GetDogWalkerIdByUserId(userId);
            return Ok(id);
        }

    }
}
