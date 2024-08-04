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

    }
}
