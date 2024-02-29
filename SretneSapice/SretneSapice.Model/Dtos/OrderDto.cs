using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class OrderDto
    {
        public int OrderId { get; set; }

        public string OrderNumber { get; set; } = null!;

        public int? UserId { get; set; }

        public int? ShippingInfoId { get; set; }

        public DateTime? Date { get; set; }

        public string Status { get; set; } = null!;

        public decimal? TotalAmount { get; set; }

        public virtual ICollection<OrderItemDto> OrderItems { get; } = new List<OrderItemDto>();

        public virtual ICollection<PaymentDto> Payments { get; } = new List<PaymentDto>();

        public virtual UserShippingInformationDto? ShippingInfo { get; set; }

        public virtual UserDto? User { get; set; }
    }
}
