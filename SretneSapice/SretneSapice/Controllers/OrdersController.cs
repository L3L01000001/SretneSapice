using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OrdersController : BaseCRUDController<OrderDto, OrderSearchObject, OrderInsertRequest, OrderInsertRequest>
    {
        private readonly IOrderService _orderService;

        public OrdersController(ILogger<BaseController<OrderDto, OrderSearchObject>> logger, IOrderService service) : base(logger, service)
        {
            _orderService = service;
        }

        [HttpPut("{orderId}/paid-order")]
        public async Task<IActionResult> CompleteOrder(int orderId)
        {
            try
            {
                var orderDto = await _orderService.PaidOrder(orderId);
                return Ok(orderDto);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("{orderId}/cancel-order")]
        public async Task<IActionResult> CancelOrder(int orderId)
        {
            try
            {
                var orderDto = await _orderService.CancelOrder(orderId);
                return Ok(orderDto);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
