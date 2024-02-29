using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class OrderItemDto
    {
        public int OrderItemId { get; set; }

        public int? OrderId { get; set; }

        public int? ProductId { get; set; }

        public int? Quantity { get; set; }

        public decimal? Subtotal { get; set; }

        public virtual OrderDto? Order { get; set; }

        public virtual ProductDto? Product { get; set; }
    }
}
