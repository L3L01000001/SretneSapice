using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class UserShippingInformation
{
    public int ShippingInfoId { get; set; }

    public int? UserId { get; set; }

    public string? Address { get; set; }

    public string? City { get; set; }

    public string? Zipcode { get; set; }

    public string? Phone { get; set; }

    public virtual ICollection<Order> Orders { get; } = new List<Order>();

    public virtual User? User { get; set; }
}
