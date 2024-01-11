using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IService<T, TSearch> _service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> service)
        {
            _logger = logger; 
            _service = service;
        }

        [HttpGet]
        public async Task<PagedResult<T>> GetAll([FromQuery]TSearch? search = null)
        {
            return await _service.GetAll(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}
