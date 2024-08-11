using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class PaymentUpdateRequest
    {
        public int? OrderId { get; set; }

        public string? TransactionId { get; set; }
    }
}
