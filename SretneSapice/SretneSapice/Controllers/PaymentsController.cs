using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PaymentsController : BaseCRUDController<PaymentDto, BaseSearchObject, PaymentInsertRequest, PaymentUpdateRequest>
    {
        private readonly IPaymentService _paymentService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public PaymentsController(ILogger<BaseController<PaymentDto, BaseSearchObject>> logger, IPaymentService service, IHttpContextAccessor httpContextAccessor) : base(logger, service)
        {
            _paymentService = service;
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpGet("initiate-payment")]
        public async Task<IActionResult> InitiatePayment(int orderId)
        {
            var returnUrl = $"{_httpContextAccessor.HttpContext.Request.Scheme}://{_httpContextAccessor.HttpContext.Request.Host}/payment/success";
            var cancelUrl = $"{_httpContextAccessor.HttpContext.Request.Scheme}://{_httpContextAccessor.HttpContext.Request.Host}/payment/cancel";

            try
            {
                var order = await _paymentService.CreatePayPalOrderAsync(orderId, returnUrl, cancelUrl);
                var paypalPaymentUrl = $"https://www.sandbox.paypal.com/checkoutnow?token={order}";

                return Ok(new { paypalUrl = paypalPaymentUrl });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Failed to initiate payment: {ex.Message}");
            }
        }

        [HttpPost("success")]
        public async Task<IActionResult> PaymentSuccess([FromQuery] string token)
        {
            try
            {
                var payment = await _paymentService.CompletePayPalOrderAsync(token);
                return Ok(new { success = true, message = "Payment successful", payment });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Failed to complete payment: {ex.Message}");
            }
        }

        [HttpPost("cancel")]
        public async Task<IActionResult> PaymentCancel()
        {
            return Ok(new { success = false, message = "Payment canceled" });
        }
    }
}
