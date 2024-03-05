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
    public class DogWalkersController : BaseCRUDController<DogWalkerDto, DogWalkerSearchObject, DogWalkerInsertRequest, DogWalkerInsertRequest>
    {
        private readonly IDogWalkerService _dogWalkerService;
        public DogWalkersController(IDogWalkerService service, ILogger<BaseController<DogWalkerDto, DogWalkerSearchObject>> logger) : base(logger, service)
        {
            _dogWalkerService = service;
        }

        [HttpGet("{dogWalkerId}/allowedActions")]
        //[Authorize(Roles = "DogWalkerVerifier, User")]
        public virtual async Task<List<string>> AllowedActions(int dogWalkerId)
        {
            return await _dogWalkerService.AllowedActions(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/approve")]
        //[Authorize(Roles = "DogWalkerVerifier")]
        public virtual async Task<DogWalkerDto> Approve(int dogWalkerId)
        {
            return await _dogWalkerService.Approve(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/reject")]
        //[Authorize(Roles = "DogWalkerVerifier")]
        public virtual async Task<DogWalkerDto> Reject(int dogWalkerId)
        {
            return await _dogWalkerService.Reject(dogWalkerId);
        }

        [HttpPut("{dogWalkerId}/cancelApplication")]
        //[Authorize(Roles = "User")]
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
        public async Task<List<DogWalkerDto>> GetDogWalkersWithMostReviewsFirst()
        {
            return await _dogWalkerService.GetDogWalkersWithMostReviewsFirst();
        }


        [HttpGet("getDogWalkersWithMostFinishedServicesFirst")]
        public async Task<List<DogWalkerDto>> GetDogWalkersWithMostFinishedServicesFirst()
        {
            return await _dogWalkerService.GetDogWalkersWithMostFinishedServicesFirst();
        }

    }
}
