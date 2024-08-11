using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PaymentsController : BaseCRUDController<PaymentDto, BaseSearchObject, PaymentInsertRequest, PaymentInsertRequest>
    {
        private readonly IPaymentService _paymentService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public PaymentsController(ILogger<BaseController<PaymentDto, BaseSearchObject>> logger, IPaymentService service, IHttpContextAccessor httpContextAccessor) : base(logger, service)
        {
            _paymentService = service;
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpGet("paymentWithOrderIdExists/{orderId}")]
        public async Task<IActionResult> PaymentWithOrderIdExists(int orderId)
        {
            int paymentId = await _paymentService.PaymentExistsInTable(orderId);
            return Ok(paymentId);
        }

        [HttpPut("update-transaction-id")]
        public async Task<IActionResult> UpdateTransactionId([FromBody] PaymentInsertRequest request)
        {
            try
            {
                await _paymentService.UpdateTransactionIdAsync(request);
                return Ok(new { message = "Transaction ID updated successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("{orderId}/complete")]
        public async Task<IActionResult> CompletePayment(int orderId)
        {
            try
            {
                var paymentDto = await _paymentService.CompletePaymentAsync(orderId);
                return Ok(paymentDto);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("{orderId}/cancel")]
        public async Task<IActionResult> CancelPayment(int orderId)
        {
            try
            {
                var paymentDto = await _paymentService.CancelPayment(orderId);
                return Ok(paymentDto);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
