using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UsersController : BaseCRUDController<UserDto, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;

        public UsersController(ILogger<BaseController<UserDto, UserSearchObject>> logger, IUserService service) : base(logger, service)
        {
            _userService = service;
        }

        [HttpPost("Login")]
        public virtual async Task<UserDto> Login(string username, string password)
        {
            return await _userService.Login(username, password);
        }

        [HttpPost("Register")]
        public virtual async Task<UserDto> Register([FromBody] UserInsertRequest registration)
        {
            return await _userService.Register(registration);
        }
    }
}