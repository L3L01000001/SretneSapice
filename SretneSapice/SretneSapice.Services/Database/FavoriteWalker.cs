using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class FavoriteWalker
{
    public int FavoriteWalkerId { get; set; }

    public int? UserId { get; set; }

    public int? DogWalkerId { get; set; }

    public virtual DogWalker? DogWalker { get; set; }

    public virtual User? User { get; set; }
}
