using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;
using SretneSapice.Services.Database;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class RolesController : BaseController<RoleDto, BaseSearchObject>
    {
        public RolesController(ILogger<BaseController<RoleDto, BaseSearchObject>> logger, IRoleService service) : base(logger, service)
        {
        }
    }
}
