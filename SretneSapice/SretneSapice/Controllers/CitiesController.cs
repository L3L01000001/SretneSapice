using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;
using SretneSapice.Services.Database;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class CitiesController : BaseController<CityDto, BaseSearchObject>
    {
        public CitiesController( ILogger<BaseController<CityDto, BaseSearchObject>> logger, ICityService service) : base(logger, service)
        {
        }
    }
}
