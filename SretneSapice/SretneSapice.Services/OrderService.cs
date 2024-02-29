using AutoMapper;
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
        public OrderService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
