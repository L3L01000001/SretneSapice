using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class PaymentService : BaseCRUDService<PaymentDto, Payment, BaseSearchObject, PaymentInsertRequest, PaymentInsertRequest>, IPaymentService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public PaymentService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public async Task<int> PaymentExistsInTable(int orderId)
        {
            var payment = await _context.Payments.Where(dw => dw.OrderId == orderId).FirstOrDefaultAsync();

            if (payment == null)
            {
                return 0;
            }
            else
                return payment.PaymentId;
        }

        public async Task<PaymentDto> CompletePaymentAsync(int orderId)
        {
            var payment = await _context.Payments
                                        .Where(p => p.OrderId == orderId)
                                        .FirstOrDefaultAsync();

            if (payment == null)
            {
                throw new Exception("Payment not found.");
            }

            payment.Status = "Completed";
            
            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentDto>(payment);
        }

        public async Task<PaymentDto> CancelPayment(int orderId)
        {
            var payment = await _context.Payments
                                        .Where(p => p.OrderId == orderId)
                                        .FirstOrDefaultAsync();

            if (payment == null)
            {
                throw new Exception("Payment not found.");
            }

            payment.Status = "Cancelled";

            await _context.SaveChangesAsync();

            return _mapper.Map<PaymentDto>(payment);
        }

        public async Task UpdateTransactionIdAsync(PaymentInsertRequest request)
        {
            var payment = await _context.Payments
                .FirstOrDefaultAsync(p => p.OrderId == request.OrderId);

            if (payment == null)
            {
                throw new Exception("Payment not found");
            }

            payment.TransactionId = request.TransactionId;
            _context.Payments.Update(payment);
            await _context.SaveChangesAsync();
        }
    }
}
