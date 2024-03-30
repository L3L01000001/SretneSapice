using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IPaymentService : ICRUDService<PaymentDto, BaseSearchObject, PaymentInsertRequest, PaymentUpdateRequest>
    {
        Task<string> CreatePayPalOrderAsync(int orderId, string returnUrl, string cancelUrl);
    }
}
