using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    internal class OrderUpdateRequest
    {
        public int? ShippingInfoId { get; set; }
        public string? Status { get; set; } 
    }
}
