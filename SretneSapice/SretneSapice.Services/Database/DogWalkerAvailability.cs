using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class DogWalkerAvailability
{
    public int DogWalkerId { get; set; }

    public DateTime Date { get; set; }

    public DateTime StartTime { get; set; }

    public DateTime EndTime { get; set; }

    public string? AvailabilityStatus { get; set; }

    public virtual DogWalker DogWalker { get; set; } = null!;
}
