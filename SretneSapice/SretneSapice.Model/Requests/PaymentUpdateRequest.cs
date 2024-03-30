using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class PaymentUpdateRequest
    {
        public string? TransactionId { get; set; }

        public string? Status { get; set; }
    }
}
