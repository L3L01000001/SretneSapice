using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Product
{
    public int ProductId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public string? Code { get; set; }

    public decimal Price { get; set; }

    public int StockQuantity { get; set; }

    public int? ProductTypeId { get; set; }

    public string? Brand { get; set; }

    public byte[]? ProductPhoto { get; set; }

    public byte[]? ProductPhotoThumb { get; set; }

    public bool? Status { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual ICollection<OrderItem> OrderItems { get; } = new List<OrderItem>();

    public virtual ProductType? ProductType { get; set; }
}
