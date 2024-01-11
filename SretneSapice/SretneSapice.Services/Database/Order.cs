using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Order
{
    public int OrderId { get; set; }

    public string OrderNumber { get; set; } = null!;

    public int? UserId { get; set; }

    public int? ShippingInfoId { get; set; }

    public DateTime? Date { get; set; }

    public string Status { get; set; } = null!;

    public decimal? TotalAmount { get; set; }

    public virtual ICollection<OrderItem> OrderItems { get; } = new List<OrderItem>();

    public virtual ICollection<Payment> Payments { get; } = new List<Payment>();

    public virtual UserShippingInformation? ShippingInfo { get; set; }

    public virtual User? User { get; set; }
}
