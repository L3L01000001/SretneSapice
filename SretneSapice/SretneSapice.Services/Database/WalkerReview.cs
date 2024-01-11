using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class WalkerReview
{
    public int ReviewId { get; set; }

    public int? DogWalkerId { get; set; }

    public int? UserId { get; set; }

    public int? Rating { get; set; }

    public string? ReviewText { get; set; }

    public DateTime? Timestamp { get; set; }

    public virtual DogWalker? DogWalker { get; set; }

    public virtual User? User { get; set; }
}
