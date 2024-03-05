using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserShippingInformationController : BaseCRUDController<UserShippingInformationDto, BaseSearchObject, UserShippingInformationInsertRequest, UserShippingInformationInsertRequest>
    {
        public UserShippingInformationController(IUserShippingInformationService service, ILogger<BaseController<UserShippingInformationDto, BaseSearchObject>> logger) : base(logger, service)
        {
        }
    }
}
