using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SretneSapice.Services.Database;

public partial class _180148Context : DbContext
{
    public _180148Context()
    {
    }

    public _180148Context(DbContextOptions<_180148Context> options)
        : base(options)
    {
    }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Comment> Comments { get; set; }

    public virtual DbSet<CommentLike> CommentLikes { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<DogWalker> DogWalkers { get; set; }

    public virtual DbSet<DogWalkerAvailability> DogWalkerAvailabilities { get; set; }

    public virtual DbSet<DogWalkerLocation> DogWalkerLocations { get; set; }

    public virtual DbSet<FavoriteWalker> FavoriteWalkers { get; set; }

    public virtual DbSet<ForumPost> ForumPosts { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderItem> OrderItems { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Product> Products { get; set; }

    public virtual DbSet<ProductType> ProductTypes { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<ServiceRequest> ServiceRequests { get; set; }

    public virtual DbSet<Tag> Tags { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    public virtual DbSet<ForumPostTag> ForumPostTags { get; set; }
    public virtual DbSet<ToDo4924> ToDo4924s { get; set; }

    public virtual DbSet<UserShippingInformation> UserShippingInformations { get; set; }

    public virtual DbSet<WalkerReview> WalkerReviews { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ForumPostTag>(entity => {
            entity.HasKey(e => new { e.PostsPostId, e.TagsTagId });

            entity.ToTable("ForumPostTag");

            entity.Property(e => e.PostsPostId).HasColumnName("PostsPostId");
            entity.Property(e => e.TagsTagId).HasColumnName("TagsTagId");
            entity.Property(e => e.PostId).HasColumnName("PostId");
            entity.Property(e => e.TagId).HasColumnName("TagId");

            entity.HasOne(pt => pt.ForumPost)
            .WithMany(p => p.ForumPostTags)
            .HasForeignKey(pt => pt.PostsPostId);

            entity.HasOne(pt => pt.Tag)
                .WithMany(t => t.ForumPostTags)
                .HasForeignKey(pt => pt.TagsTagId);

        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.ToTable("City");

            entity.Property(e => e.CityId)
                .ValueGeneratedNever()
                .HasColumnName("CityID");
            entity.Property(e => e.CountryId).HasColumnName("CountryID");
            entity.Property(e => e.Name).HasMaxLength(50);

            entity.HasOne(d => d.Country).WithMany(p => p.Cities)
                .HasForeignKey(d => d.CountryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_City_City");
        });

        modelBuilder.Entity<Comment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__Comment__C3B4DFAAD757BB40");

            entity.ToTable("Comment");

            entity.Property(e => e.CommentId).HasColumnName("CommentID");
            entity.Property(e => e.CommentContent).HasMaxLength(200);
            entity.Property(e => e.PostId).HasColumnName("PostID");
            entity.Property(e => e.Timestamp)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Post).WithMany(p => p.Comments)
                .HasForeignKey(d => d.PostId)
                .HasConstraintName("FK__Comment__PostID__43D61337");

            entity.HasOne(d => d.User).WithMany(p => p.Comments)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Comment__UserID__44CA3770");
        });

        modelBuilder.Entity<CommentLike>(entity =>
        {
            entity.HasKey(e => e.LikeId).HasName("PK__CommentL__A2922CF4DED4785D");

            entity.ToTable("CommentLike");

            entity.Property(e => e.LikeId).HasColumnName("LikeID");
            entity.Property(e => e.CommentId).HasColumnName("CommentID");
            entity.Property(e => e.Timestamp)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Comment).WithMany(p => p.CommentLikes)
                .HasForeignKey(d => d.CommentId)
                .HasConstraintName("FK__CommentLi__Comme__489AC854");

            entity.HasOne(d => d.User).WithMany(p => p.CommentLikes)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__CommentLi__UserI__498EEC8D");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.ToTable("Country");

            entity.Property(e => e.CountryId)
                .ValueGeneratedNever()
                .HasColumnName("CountryID");
            entity.Property(e => e.CountryName).HasMaxLength(40);
        });

        modelBuilder.Entity<DogWalker>(entity =>
        {
            entity.HasKey(e => e.DogWalkerId).HasName("PK__DogWalke__7AE957542C4A8B9E");

            entity.ToTable("DogWalker");

            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.CityId).HasColumnName("CityID");
            entity.Property(e => e.Experience).HasMaxLength(350);
            entity.Property(e => e.IsApproved).HasColumnName("isApproved");
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(30);
            entity.Property(e => e.Surname).HasMaxLength(50);
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.City).WithMany(p => p.DogWalkers)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__DogWalker__CityI__4D5F7D71");

            entity.HasOne(d => d.User).WithMany(p => p.DogWalkers)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__DogWalker__UserI__4C6B5938");
        });

        modelBuilder.Entity<DogWalkerAvailability>(entity =>
        {
            entity.HasKey(e => new { e.DogWalkerId, e.Date, e.StartTime, e.EndTime }).HasName("PK__DogWalke__A9F7DEBDFB5F1C93");

            entity.ToTable("DogWalkerAvailability");

            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.Date).HasColumnType("date");
            entity.Property(e => e.StartTime).HasColumnType("datetime");
            entity.Property(e => e.EndTime).HasColumnType("datetime");
            entity.Property(e => e.AvailabilityStatus).HasMaxLength(20);

            entity.HasOne(d => d.DogWalker).WithMany(p => p.DogWalkerAvailabilities)
                .HasForeignKey(d => d.DogWalkerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DogWalker__DogWa__503BEA1C");
        });

        modelBuilder.Entity<DogWalkerLocation>(entity =>
        {
            entity.HasKey(e => e.DogWalkerId).HasName("PK__DogWalke__82636EF78AE5B872");

            entity.ToTable("DogWalkerLocation");

            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.Timestamp).HasColumnType("date");

            entity.HasOne(d => d.DogWalker).WithMany(p => p.DogWalkerLocations)
                .HasForeignKey(d => d.DogWalkerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DogWalker__DogWa__531856C7");
        });

        modelBuilder.Entity<FavoriteWalker>(entity =>
        {
            entity.HasKey(e => e.FavoriteWalkerId).HasName("PK__Favorite__8F7DAA3D91565AE6");

            entity.ToTable("FavoriteWalker");

            entity.Property(e => e.FavoriteWalkerId).HasColumnName("FavoriteWalkerID");
            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.DogWalker).WithMany(p => p.FavoriteWalkers)
                .HasForeignKey(d => d.DogWalkerId)
                .HasConstraintName("FK__FavoriteW__DogWa__56E8E7AB");

            entity.HasOne(d => d.User).WithMany(p => p.FavoriteWalkers)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__FavoriteW__UserI__55F4C372");
        });

        modelBuilder.Entity<ForumPost>(entity =>
        {
            entity.HasKey(e => e.PostId).HasName("PK__ForumPos__AA1260380DF73D3A");

            entity.ToTable("ForumPost");

            entity.Property(e => e.PostId).HasColumnName("PostID");
            entity.Property(e => e.PostContent).HasMaxLength(500);
            entity.Property(e => e.Timestamp)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Title).HasMaxLength(70);
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.User).WithMany(p => p.ForumPosts)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__ForumPost__UserI__40058253");

            entity.HasMany(fp => fp.ForumPostTags)
                .WithOne(fpt => fpt.ForumPost)
                .HasForeignKey(fpt => fpt.PostsPostId);

        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Order__C3905BAFD5DE5E5D");

            entity.ToTable("Order");

            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.Date).HasColumnType("datetime");
            entity.Property(e => e.OrderNumber).HasMaxLength(50);
            entity.Property(e => e.ShippingInfoId).HasColumnName("ShippingInfoID");
            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.TotalAmount).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.ShippingInfo).WithMany(p => p.Orders)
                .HasForeignKey(d => d.ShippingInfoId)
                .HasConstraintName("FK__Order__ShippingI__5AB9788F");

            entity.HasOne(d => d.User).WithMany(p => p.Orders)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Order__UserID__59C55456");
        });

        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.HasKey(e => e.OrderItemId).HasName("PK__OrderIte__57ED06A10CF4F6C4");

            entity.ToTable("OrderItem");

            entity.Property(e => e.OrderItemId).HasColumnName("OrderItemID");
            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.ProductId).HasColumnName("ProductID");
            entity.Property(e => e.Subtotal).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__OrderItem__Order__5D95E53A");

            entity.HasOne(d => d.Product).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK__OrderItem__Produ__5E8A0973");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__Payment__9B556A581D06CA63");

            entity.ToTable("Payment");

            entity.Property(e => e.PaymentId).HasColumnName("PaymentID");
            entity.Property(e => e.Amount).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.PaymentMethod).HasMaxLength(50);
            entity.Property(e => e.Status).HasMaxLength(30);
            entity.Property(e => e.TransactionId)
                .HasMaxLength(100)
                .HasColumnName("TransactionID");

            entity.HasOne(d => d.Order).WithMany(p => p.Payments)
                .HasForeignKey(d => d.OrderId)
                .HasConstraintName("FK__Payment__OrderID__6166761E");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("PK__Product__B40CC6ED550AD9A5");

            entity.ToTable("Product");

            entity.Property(e => e.ProductId).HasColumnName("ProductID");
            entity.Property(e => e.Brand).HasMaxLength(100);
            entity.Property(e => e.Code).HasMaxLength(50);
            entity.Property(e => e.CreatedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.Name).HasMaxLength(150);
            entity.Property(e => e.Price).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.ProductTypeId).HasColumnName("ProductTypeID");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.ProductType).WithMany(p => p.Products)
                .HasForeignKey(d => d.ProductTypeId)
                .HasConstraintName("FK__Product__Product__3864608B");
        });

        modelBuilder.Entity<ProductType>(entity =>
        {
            entity.HasKey(e => e.ProductTypeId).HasName("PK_ItemType");

            entity.ToTable("ProductType");

            entity.Property(e => e.ProductTypeId)
                .ValueGeneratedNever()
                .HasColumnName("ProductTypeID");
            entity.Property(e => e.ProductTypeName).HasMaxLength(50);
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.ToTable("Role");

            entity.Property(e => e.RoleId)
                .ValueGeneratedNever()
                .HasColumnName("RoleID");
            entity.Property(e => e.Name).HasMaxLength(50);
        });


        modelBuilder.Entity<ServiceRequest>(entity =>
        {
            entity.HasKey(e => e.ServiceRequestId).HasName("PK__ServiceR__790F6CABD9E7C998");

            entity.ToTable("ServiceRequest");

            entity.Property(e => e.ServiceRequestId).HasColumnName("ServiceRequestID");
            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.EndTime).HasColumnType("datetime");
            entity.Property(e => e.StartTime).HasColumnType("datetime");
            entity.Property(e => e.Date).HasColumnType("datetime");
            entity.Property(e => e.DogBreed).HasMaxLength(50);
            entity.Property(e => e.Status).HasMaxLength(20);
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.DogWalker).WithMany(p => p.ServiceRequests)
                .HasForeignKey(d => d.DogWalkerId)
                .HasConstraintName("FK__ServiceRe__DogWa__6DCC4D03");

            entity.HasOne(d => d.User).WithMany(p => p.ServiceRequests)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__ServiceRe__UserI__6EC0713C");
        });

        modelBuilder.Entity<Tag>(entity =>
        {
            entity.HasKey(e => e.TagId).HasName("PK__Tag__657CFA4C6B63B1A6");

            entity.ToTable("Tag");

            entity.Property(e => e.TagId).HasColumnName("TagID");
            entity.Property(e => e.TagName).HasMaxLength(100);

            entity.HasMany(fp => fp.ForumPostTags)
                .WithOne(fpt => fpt.Tag)
                .HasForeignKey(fpt => fpt.TagsTagId);
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__User__1788CCAC8120D4EF");

            entity.ToTable("User");

            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.CityId).HasColumnName("CityID");
            entity.Property(e => e.Email).HasMaxLength(30);
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.PasswordHash).HasMaxLength(50);
            entity.Property(e => e.PasswordSalt).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(30);
            entity.Property(e => e.Surname).HasMaxLength(50);
            entity.Property(e => e.Username).HasMaxLength(50);

            entity.HasOne(d => d.City).WithMany(p => p.Users)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__User__CityID__2DE6D218");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.UserRoleId).HasName("PK__UserRole__3D978A552146AC3A");

            entity.ToTable("UserRole");

            entity.Property(e => e.UserRoleId).HasColumnName("UserRoleID");
            entity.Property(e => e.DateOfChange).HasColumnType("datetime");
            entity.Property(e => e.RoleId).HasColumnName("RoleID");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK__UserRole__RoleID__31B762FC");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__UserRole__UserID__30C33EC3");
        });

        modelBuilder.Entity<UserShippingInformation>(entity =>
        {
            entity.HasKey(e => e.ShippingInfoId).HasName("PK__UserShip__A72E5D95FFE96546");

            entity.ToTable("UserShippingInformation");

            entity.Property(e => e.ShippingInfoId).HasColumnName("ShippingInfoID");
            entity.Property(e => e.Address).HasMaxLength(70);
            entity.Property(e => e.City).HasMaxLength(50);
            entity.Property(e => e.Phone).HasMaxLength(50);
            entity.Property(e => e.UserId).HasColumnName("UserID");
            entity.Property(e => e.Zipcode)
                .HasMaxLength(20)
                .HasColumnName("ZIPCode");

            entity.HasOne(d => d.User).WithMany(p => p.UserShippingInformations)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__UserShipp__UserI__3493CFA7");
        });

        modelBuilder.Entity<WalkerReview>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK__WalkerRe__74BC79AE43C20541");

            entity.ToTable("WalkerReview");

            entity.Property(e => e.ReviewId).HasColumnName("ReviewID");
            entity.Property(e => e.DogWalkerId).HasColumnName("DogWalkerID");
            entity.Property(e => e.ReviewText).HasMaxLength(150);
            entity.Property(e => e.Timestamp).HasColumnType("datetime");
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.DogWalker).WithMany(p => p.WalkerReviews)
                .HasForeignKey(d => d.DogWalkerId)
                .HasConstraintName("FK__WalkerRev__DogWa__719CDDE7");

            entity.HasOne(d => d.User).WithMany(p => p.WalkerReviews)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__WalkerRev__UserI__72910220");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
