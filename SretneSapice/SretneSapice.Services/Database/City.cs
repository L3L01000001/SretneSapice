using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class City
{
    public int CityId { get; set; }

    public string Name { get; set; } = null!;

    public int CountryId { get; set; }

    public virtual Country Country { get; set; } = null!;

    public virtual ICollection<DogWalker> DogWalkers { get; } = new List<DogWalker>();

    public virtual ICollection<User> Users { get; } = new List<User>();
}
