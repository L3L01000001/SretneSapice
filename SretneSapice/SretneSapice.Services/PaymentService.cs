using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Clients;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class PaymentService : BaseCRUDService<PaymentDto, Payment, BaseSearchObject, PaymentInsertRequest, PaymentUpdateRequest>, IPaymentService
    {
        private readonly PaypalClient _paypalClient;
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public PaymentService(_180148Context context, IMapper mapper, PaypalClient paypalClient, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _paypalClient = paypalClient;
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public async Task<string> CreatePayPalOrderAsync(int orderId, string returnUrl, string cancelUrl)
        {
            var userOrder = await _context.Orders
                                    .Where(o => o.UserId == LoggedInUserId && o.OrderId == orderId)
                                    .FirstOrDefaultAsync();

            if (userOrder == null)
            {
                throw new Exception("User's pending order not found.");
            }

            decimal total = userOrder.TotalAmount ?? 0;

            var paypalOrderId = await _paypalClient.CreateOrderAsync(total, returnUrl, cancelUrl);

            var payment = new Payment
            {
                OrderId = userOrder.OrderId,
                PaymentMethod = "Paypal",
                Status = "Pending", 
                Amount = total,
                TransactionId = paypalOrderId
            };

            _context.Payments.Add(payment);

            await _context.SaveChangesAsync();

            return paypalOrderId;
        }

        public async Task<PaymentDto> CompletePayPalOrderAsync(string token)
        {
            var paypalOrderId = token;

            var payment = await _context.Payments
                                        .Where(p => p.TransactionId == paypalOrderId)
                                        .FirstOrDefaultAsync();

            if (payment == null)
            {
                throw new Exception("Payment not found.");
            }

            var isPaymentSuccessful = await _paypalClient.VerifyOrderAsync(token);
            if (isPaymentSuccessful)
            {
                payment.Status = "Completed";
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new Exception("Payment verification failed.");
            }

            return _mapper.Map<PaymentDto>(payment);
        }
    }
}
