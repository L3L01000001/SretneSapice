using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class User
{
    public int UserId { get; set; }

    public string? Name { get; set; }

    public string? Surname { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public string? Username { get; set; }

    public string? PasswordHash { get; set; }

    public string? PasswordSalt { get; set; }

    public bool? Status { get; set; }

    public byte[]? ProfilePhoto { get; set; }

    public byte[]? ProfilePhotoThumb { get; set; }

    public int? CityId { get; set; }

    public virtual City? City { get; set; }

    public virtual ICollection<CommentLike> CommentLikes { get; } = new List<CommentLike>();

    public virtual ICollection<Comment> Comments { get; } = new List<Comment>();

    public virtual ICollection<DogWalker> DogWalkers { get; } = new List<DogWalker>();

    public virtual ICollection<FavoriteWalker> FavoriteWalkers { get; } = new List<FavoriteWalker>();

    public virtual ICollection<ForumPost> ForumPosts { get; } = new List<ForumPost>();

    public virtual ICollection<Order> Orders { get; } = new List<Order>();

    public virtual ICollection<ScheduledService> ScheduledServices { get; } = new List<ScheduledService>();

    public virtual ICollection<ServiceRequest> ServiceRequests { get; } = new List<ServiceRequest>();

    public virtual ICollection<UserRole> UserRoles { get; } = new List<UserRole>();

    public virtual ICollection<UserShippingInformation> UserShippingInformations { get; } = new List<UserShippingInformation>();

    public virtual ICollection<WalkerReview> WalkerReviews { get; } = new List<WalkerReview>();
}
