﻿using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class ProductType
{
    public int ProductTypeId { get; set; }

    public string ProductTypeName { get; set; } = null!;

    public virtual ICollection<Product> Products { get; } = new List<Product>();
}
