using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Constants;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class OrderService : BaseCRUDService<OrderDto, Order, OrderSearchObject, OrderInsertRequest, OrderInsertRequest>, IOrderService
    {
        private const string Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        public OrderService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Order> AddInclude(IQueryable<Order> query, OrderSearchObject? search = null)
        {
            query = query.Include(x => x.User).Include(x => x.OrderItems).ThenInclude(orderItem => orderItem.Product);
            return base.AddInclude(query, search);
        }

        public override IQueryable<Order> AddFilter(IQueryable<Order> query, OrderSearchObject? search = null)
        {
            if (search.UserId != null)
            {
                query = query.Where(x => x.UserId == search.UserId && x.Status == "In Cart");
            }

            if(!string.IsNullOrWhiteSpace(search?.Status) && OrderStatuses.ListOfOrderStatuses.Contains(search.Status)) {
                query = query.Where(x => x.Status == search.Status);
            }

            if(search?.Top5 == true)
            {
                query = query.OrderByDescending(x => x.TotalAmount)
                    .Take(5);
            }

            if (!string.IsNullOrWhiteSpace(search?.OrderNumber))
            {
                query = query.Where(x => x.OrderNumber.Contains(search.OrderNumber));
            }

            return base.AddFilter(query, search);
        }

        public async Task<string> GenerateUniqueOrderNumber()
        {
            string orderNumber;
            do
            {
                orderNumber = GenerateRandomOrderNumber();
            } while (await _context.Orders.AnyAsync(o => o.OrderNumber == orderNumber));

            return orderNumber;
        }

        private string GenerateRandomOrderNumber()
        {
            var random = new Random();
            var orderNumber = new StringBuilder();
            for (int i = 0; i < 7; i++)
            {
                orderNumber.Append(Characters[random.Next(Characters.Length)]);
            }
            return orderNumber.ToString();
        }

        public async Task<decimal?> CalculateTotalAmount(int orderId)
        {
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                .FirstOrDefaultAsync(o => o.OrderId == orderId);

            if (order == null)
            {
                throw new InvalidOperationException("Order not found");
            }

            decimal? totalAmount = order.OrderItems.Sum(item => item.Subtotal);
            return totalAmount;
        }

        public async Task UpdateTotalAmount(int orderId)
        {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null)
            {
                throw new InvalidOperationException("Order not found");
            }

            decimal? totalAmount = await CalculateTotalAmount(orderId);
            order.TotalAmount = totalAmount;

            await _context.SaveChangesAsync();
        }

        public async Task<OrderDto> PaidOrder(int orderId)
        {
            var order = await _context.Orders
                                        .Where(p => p.OrderId == orderId && p.Status == OrderStatuses.InCart)
                                        .FirstOrDefaultAsync();

            if (order == null)
            {
                throw new Exception("Order not found.");
            }

            order.Status = OrderStatuses.Paid;

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderDto>(order);
        }

        public async Task<OrderDto> CancelOrder(int orderId)
        {
            var order = await _context.Orders
                                        .Where(p => p.OrderId == orderId && p.Status == OrderStatuses.InCart)
                                        .FirstOrDefaultAsync();

            if (order == null)
            {
                throw new Exception("Order not found.");
            }

            order.Status = OrderStatuses.Cancelled;

            await _context.SaveChangesAsync();

            return _mapper.Map<OrderDto>(order);
        }
    }
}
