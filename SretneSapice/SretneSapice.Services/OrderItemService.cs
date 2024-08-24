using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Constants;
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
    public class OrderItemService : BaseCRUDService<OrderItemDto, OrderItem, OrderItemSearchObject, OrderItemInsertRequest, OrderItemUpdateRequest>, IOrderItemService
    {
        public int LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IOrderService _orderService;
        public OrderItemService(_180148Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor, IOrderService orderService) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            _orderService = orderService;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }

        public override IQueryable<OrderItem> AddInclude(IQueryable<OrderItem> query, OrderItemSearchObject? search = null)
        {
            query = query.Include(x => x.Product).Include(x => x.Order);
            return base.AddInclude(query, search);
        }

        public override IQueryable<OrderItem> AddFilter(IQueryable<OrderItem> query, OrderItemSearchObject? search = null)
        {
            if (search.OrderId != null)
            {
                query = query.Where(x => x.OrderId == search.OrderId);
            }

            return base.AddFilter(query, search);
        }

        public override async Task<OrderItemDto> Insert(OrderItemInsertRequest insertRequest)
        {
            var order = await _context.Orders.FirstOrDefaultAsync(o => o.UserId == LoggedInUserId && o.Status == OrderStatuses.InCart);
            
    
            if (order == null)
            {
                order = new Order
                {
                    UserId = LoggedInUserId,
                    Status = OrderStatuses.InCart,
                    Date = DateTime.Now,
                    OrderNumber = await _orderService.GenerateUniqueOrderNumber()
            };
                _context.Orders.Add(order);
                await _context.SaveChangesAsync();
            }

            var existingOrderItem = await _context.OrderItems
         .FirstOrDefaultAsync(oi => oi.OrderId == order.OrderId && oi.ProductId == insertRequest.ProductId);

            var product = await _context.Products.FirstOrDefaultAsync(p => p.ProductId == insertRequest.ProductId);
            if (product == null)
            {
                throw new Exception("Product not found");
            }


            if (existingOrderItem != null)
            {
                existingOrderItem.Quantity += insertRequest.Quantity;
                existingOrderItem.Subtotal = existingOrderItem.Quantity * product.Price;

                await _context.SaveChangesAsync();
            }
            else
            {
                insertRequest.Subtotal = insertRequest.Quantity * product.Price;
                insertRequest.OrderId = order.OrderId;

                var orderItemEntity = _mapper.Map<OrderItem>(insertRequest);

                await _context.OrderItems.AddAsync(orderItemEntity);
                await _context.SaveChangesAsync();
            }

            order.TotalAmount = await _orderService.CalculateTotalAmount(order.OrderId);

            await _context.SaveChangesAsync();

            return existingOrderItem != null
                    ? _mapper.Map<OrderItemDto>(existingOrderItem)
                    : _mapper.Map<OrderItemDto>(insertRequest);
        }

        public override async Task<OrderItemDto> Update(int id, OrderItemUpdateRequest updateRequest)
        {
            var orderItem = await _context.OrderItems.FindAsync(id);
            if (orderItem == null)
            {
                throw new Exception("Such order item does not exist");
            }

            orderItem.Quantity = updateRequest.Quantity;

            var product = await _context.Products.FirstOrDefaultAsync(p => p.ProductId == orderItem.ProductId);

            orderItem.Subtotal = orderItem.Quantity * product.Price;

            await _context.SaveChangesAsync();

            var order = await _context.Orders.FirstOrDefaultAsync(o => o.UserId == LoggedInUserId && o.Status == OrderStatuses.InCart);

            await _orderService.UpdateTotalAmount(order.OrderId);

            return _mapper.Map<OrderItemDto>(orderItem);
        }

        public override async Task<OrderItemDto> HardDelete(int id)
        {
            var order = await _context.Orders
         .FirstOrDefaultAsync(o => o.UserId == LoggedInUserId && o.Status == OrderStatuses.InCart);

            var deletedItem = await base.HardDelete(id);

            if (order != null)
            {
                await _orderService.UpdateTotalAmount(order.OrderId);
            }

            return deletedItem;
        }
    }
}
