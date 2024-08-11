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
    public interface IOrderService : ICRUDService<OrderDto, OrderSearchObject, OrderInsertRequest, OrderInsertRequest>
    {
        Task<decimal?> CalculateTotalAmount(int orderId);
        Task UpdateTotalAmount(int orderId);
        Task<string> GenerateUniqueOrderNumber();
        Task<OrderDto> PaidOrder(int orderId);
        Task<OrderDto> CancelOrder(int orderId);
    }
}
