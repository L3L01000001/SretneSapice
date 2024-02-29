using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OrderItemsController : BaseCRUDController<OrderItemDto, OrderItemSearchObject, OrderItemInsertRequest, OrderItemUpdateRequest>
    {
        public OrderItemsController(IOrderItemService service, ILogger<BaseController<OrderItemDto, OrderItemSearchObject>> logger) : base(logger, service)
        {
        }
    }
}
