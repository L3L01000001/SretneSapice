using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class DogWalkerLocation
{
    public int DogWalkerId { get; set; }

    public DateTime Timestamp { get; set; }

    public double? Latitude { get; set; }

    public double? Longitude { get; set; }

    public virtual DogWalker DogWalker { get; set; } = null!;
}
