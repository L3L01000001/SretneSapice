﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
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
    }
}
