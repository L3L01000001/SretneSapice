using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class OrderInsertRequest
    {
        public string OrderNumber { get; set; } = null!;

        public int? UserId { get; set; }

        public int? ShippingInfoId { get; set; }

        public DateTime? Date { get; set; }

        public string Status { get; set; } = null!;

        public decimal? TotalAmount { get; set; }
    }
}
