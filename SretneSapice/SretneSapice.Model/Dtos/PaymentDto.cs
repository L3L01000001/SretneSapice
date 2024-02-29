using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class PaymentDto
    {
        public int PaymentId { get; set; }

        public int? OrderId { get; set; }

        public string? PaymentMethod { get; set; }

        public string? TransactionId { get; set; }

        public string? Status { get; set; }

        public decimal? Amount { get; set; }

        public virtual OrderDto? Order { get; set; }
    }
}
