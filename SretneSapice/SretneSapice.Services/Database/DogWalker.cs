using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class DogWalker
{
    public int DogWalkerId { get; set; }

    public int? UserId { get; set; }

    public int? CityId { get; set; }

    public string Name { get; set; } = null!;

    public string Surname { get; set; } = null!;

    public int Age { get; set; }

    public string Phone { get; set; } = null!;

    public string Experience { get; set; } = null!;

    public byte[] DogWalkerPhoto { get; set; } = null!;
    public byte[]? DogWalkerPhotoThumb { get; set; } = null!;

    public int? Rating { get; set; }

    public bool? IsApproved { get; set; }

    public string Status { get; set; }

    public virtual City? City { get; set; }

    public virtual ICollection<DogWalkerAvailability> DogWalkerAvailabilities { get; } = new List<DogWalkerAvailability>();

    public virtual ICollection<DogWalkerLocation> DogWalkerLocations { get; } = new List<DogWalkerLocation>();

    public virtual ICollection<FavoriteWalker> FavoriteWalkers { get; } = new List<FavoriteWalker>();

    public virtual ICollection<ServiceRequest> ServiceRequests { get; } = new List<ServiceRequest>();

    public virtual User? User { get; set; }

    public virtual ICollection<WalkerReview> WalkerReviews { get; } = new List<WalkerReview>();
}
