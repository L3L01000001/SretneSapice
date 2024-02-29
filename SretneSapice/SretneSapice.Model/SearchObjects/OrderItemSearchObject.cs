using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class OrderItemSearchObject : BaseSearchObject
    {
        public int? OrderId { get; set; }

        public int? ProductId { get; set; }

        public int? Quantity { get; set; }

        public decimal? Subtotal { get; set; }
    }
}
