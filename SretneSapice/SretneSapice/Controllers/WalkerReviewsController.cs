using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WalkerReviewsController : BaseCRUDController<WalkerReviewDto, BaseSearchObject, WalkerReviewInsertRequest, WalkerReviewInsertRequest>
    {
        private readonly IWalkerReviewService _walkerReviewService;
        public WalkerReviewsController(IWalkerReviewService service, ILogger<BaseController<WalkerReviewDto, BaseSearchObject>> logger) : base(logger, service)
        {
            _walkerReviewService = service;
        }

        [HttpGet("{dogWalkerId}/UpdateDogWalkerRating")]
        public async Task UpdateDogWalkerRating(int dogWalkerId)
        {
            await _walkerReviewService.UpdateDogWalkerRating(dogWalkerId);
        }
    }
}
