using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Country
{
    public int CountryId { get; set; }

    public string CountryName { get; set; } = null!;

    public virtual ICollection<City> Cities { get; } = new List<City>();
}
