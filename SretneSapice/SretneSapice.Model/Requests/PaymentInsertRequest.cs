using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class PaymentInsertRequest
    {
        public int? OrderId { get; set; }

        public string? PaymentMethod { get; set; }

        public string? TransactionId { get; set; }

        public string? Status { get; set; }

        public decimal? Amount { get; set; }
    }
}
