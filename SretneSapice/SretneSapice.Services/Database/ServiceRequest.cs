using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class ServiceRequest
{
    public int ServiceRequestId { get; set; }

    public int? DogWalkerId { get; set; }

    public int? UserId { get; set; }

    public DateTime? StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public string? Status { get; set; }

    public virtual DogWalker? DogWalker { get; set; }

    public virtual User? User { get; set; }
}
