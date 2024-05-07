using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;
using System.Text;

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

        [HttpGet("Authenticate")]
        [AllowAnonymous]
        public async Task<UserDto> Authenticate()
        {
            string authorization = HttpContext.Request.Headers["Authorization"];

            string encodedHeader = authorization["Basic ".Length..].Trim();

            Encoding encoding = Encoding.GetEncoding("iso-8859-1");
            string usernamePassword = encoding.GetString(Convert.FromBase64String(encodedHeader));

            int seperatorIndex = usernamePassword.IndexOf(':');

            return await ((IUserService)_service).Login(usernamePassword.Substring(0, seperatorIndex), usernamePassword[(seperatorIndex + 1)..]);
        }
    }
}