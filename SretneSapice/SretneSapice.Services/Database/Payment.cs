﻿using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Payment
{
    public int PaymentId { get; set; }

    public int? OrderId { get; set; }

    public string? PaymentMethod { get; set; }

    public string? TransactionId { get; set; }

    public string? Status { get; set; }

    public decimal? Amount { get; set; }

    public virtual Order? Order { get; set; }
}
