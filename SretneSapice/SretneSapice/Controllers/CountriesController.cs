using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;
using SretneSapice.Services.Database;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class CountriesController : BaseController<CountryDto, BaseSearchObject>
    {
        public CountriesController(ILogger<BaseController<CountryDto, BaseSearchObject>> logger, IService<CountryDto, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}
