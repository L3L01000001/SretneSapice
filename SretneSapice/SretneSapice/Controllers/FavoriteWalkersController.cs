using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoriteWalkersController : BaseCRUDController<FavoriteWalkerDto, FavoriteDogWalkerSearchObject, FavoriteWalkerInsertRequest, FavoriteWalkerInsertRequest>
    {
        private readonly IFavoriteWalkerService _favoriteWalkerService;
        public FavoriteWalkersController(IFavoriteWalkerService service, ILogger<BaseController<FavoriteWalkerDto, FavoriteDogWalkerSearchObject>> logger) : base(logger, service)
        {
            _favoriteWalkerService = service;
        }

        [HttpGet("numberOfFavoriteWalkers")]
        public int FavoriteWalkersTotalByUserId()
        {
            var numberOfFavoriteWalkersTotalByUserId = _favoriteWalkerService.FavoriteWalkersTotalByUserId();

            return numberOfFavoriteWalkersTotalByUserId;
        }
    }
}
