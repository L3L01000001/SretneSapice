using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class Init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Country",
                columns: table => new
                {
                    CountryID = table.Column<int>(type: "int", nullable: false),
                    CountryName = table.Column<string>(type: "nvarchar(40)", maxLength: 40, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Country", x => x.CountryID);
                });

            migrationBuilder.CreateTable(
                name: "ProductType",
                columns: table => new
                {
                    ProductTypeID = table.Column<int>(type: "int", nullable: false),
                    ProductTypeName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ItemType", x => x.ProductTypeID);
                });

            migrationBuilder.CreateTable(
                name: "Role",
                columns: table => new
                {
                    RoleID = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Role", x => x.RoleID);
                });

            migrationBuilder.CreateTable(
                name: "Tag",
                columns: table => new
                {
                    TagID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TagName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Tag__657CFA4C6B63B1A6", x => x.TagID);
                });

            migrationBuilder.CreateTable(
                name: "City",
                columns: table => new
                {
                    CityID = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CountryID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_City", x => x.CityID);
                    table.ForeignKey(
                        name: "FK_City_City",
                        column: x => x.CountryID,
                        principalTable: "Country",
                        principalColumn: "CountryID");
                });

            migrationBuilder.CreateTable(
                name: "Product",
                columns: table => new
                {
                    ProductID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    Code = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Price = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    StockQuantity = table.Column<int>(type: "int", nullable: false),
                    ProductTypeID = table.Column<int>(type: "int", nullable: true),
                    Brand = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    ProductPhoto = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ProductPhotoThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    UpdatedDate = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Product__B40CC6ED550AD9A5", x => x.ProductID);
                    table.ForeignKey(
                        name: "FK__Product__Product__3864608B",
                        column: x => x.ProductTypeID,
                        principalTable: "ProductType",
                        principalColumn: "ProductTypeID");
                });

            migrationBuilder.CreateTable(
                name: "User",
                columns: table => new
                {
                    UserID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Surname = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    Phone = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PasswordSalt = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    ProfilePhoto = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    ProfilePhotoThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    CityID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__User__1788CCAC8120D4EF", x => x.UserID);
                    table.ForeignKey(
                        name: "FK__User__CityID__2DE6D218",
                        column: x => x.CityID,
                        principalTable: "City",
                        principalColumn: "CityID");
                });

            migrationBuilder.CreateTable(
                name: "DogWalker",
                columns: table => new
                {
                    DogWalkerID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    CityID = table.Column<int>(type: "int", nullable: true),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Surname = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Age = table.Column<int>(type: "int", nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Experience = table.Column<string>(type: "nvarchar(350)", maxLength: 350, nullable: false),
                    DogWalkerPhoto = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    DogWalkerPhotoThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: true),
                    isApproved = table.Column<bool>(type: "bit", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__DogWalke__7AE957542C4A8B9E", x => x.DogWalkerID);
                    table.ForeignKey(
                        name: "FK__DogWalker__CityI__4D5F7D71",
                        column: x => x.CityID,
                        principalTable: "City",
                        principalColumn: "CityID");
                    table.ForeignKey(
                        name: "FK__DogWalker__UserI__4C6B5938",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "ForumPost",
                columns: table => new
                {
                    PostID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    Title = table.Column<string>(type: "nvarchar(70)", maxLength: 70, nullable: false),
                    PostContent = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    Photo = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    PhotoThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    LikesCount = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__ForumPos__AA1260380DF73D3A", x => x.PostID);
                    table.ForeignKey(
                        name: "FK__ForumPost__UserI__40058253",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "UserRole",
                columns: table => new
                {
                    UserRoleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    RoleID = table.Column<int>(type: "int", nullable: true),
                    DateOfChange = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__UserRole__3D978A552146AC3A", x => x.UserRoleID);
                    table.ForeignKey(
                        name: "FK__UserRole__RoleID__31B762FC",
                        column: x => x.RoleID,
                        principalTable: "Role",
                        principalColumn: "RoleID");
                    table.ForeignKey(
                        name: "FK__UserRole__UserID__30C33EC3",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "UserShippingInformation",
                columns: table => new
                {
                    ShippingInfoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    Address = table.Column<string>(type: "nvarchar(70)", maxLength: 70, nullable: true),
                    City = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    ZIPCode = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Phone = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__UserShip__A72E5D95FFE96546", x => x.ShippingInfoID);
                    table.ForeignKey(
                        name: "FK__UserShipp__UserI__3493CFA7",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "DogWalkerAvailability",
                columns: table => new
                {
                    DogWalkerID = table.Column<int>(type: "int", nullable: false),
                    Date = table.Column<DateTime>(type: "date", nullable: false),
                    Hour = table.Column<TimeSpan>(type: "time", nullable: false),
                    AvailabilityStatus = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__DogWalke__A9F7DEBDFB5F1C93", x => new { x.DogWalkerID, x.Date, x.Hour });
                    table.ForeignKey(
                        name: "FK__DogWalker__DogWa__503BEA1C",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                });

            migrationBuilder.CreateTable(
                name: "DogWalkerLocation",
                columns: table => new
                {
                    DogWalkerID = table.Column<int>(type: "int", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "date", nullable: false),
                    Latitude = table.Column<double>(type: "float", nullable: true),
                    Longitude = table.Column<double>(type: "float", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__DogWalke__82636EF78AE5B872", x => new { x.DogWalkerID, x.Timestamp });
                    table.ForeignKey(
                        name: "FK__DogWalker__DogWa__531856C7",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                });

            migrationBuilder.CreateTable(
                name: "FavoriteWalker",
                columns: table => new
                {
                    FavoriteWalkerID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    DogWalkerID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Favorite__8F7DAA3D91565AE6", x => x.FavoriteWalkerID);
                    table.ForeignKey(
                        name: "FK__FavoriteW__DogWa__56E8E7AB",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                    table.ForeignKey(
                        name: "FK__FavoriteW__UserI__55F4C372",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "ScheduledService",
                columns: table => new
                {
                    ServiceID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DogWalkerID = table.Column<int>(type: "int", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    StartTime = table.Column<DateTime>(type: "datetime", nullable: true),
                    EndTime = table.Column<DateTime>(type: "datetime", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Schedule__C51BB0EAED6F0B2E", x => x.ServiceID);
                    table.ForeignKey(
                        name: "FK__Scheduled__DogWa__69FBBC1F",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                    table.ForeignKey(
                        name: "FK__Scheduled__UserI__6AEFE058",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "ServiceRequest",
                columns: table => new
                {
                    ServiceRequestID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DogWalkerID = table.Column<int>(type: "int", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    StartTime = table.Column<TimeSpan>(type: "time", nullable: true),
                    EndTime = table.Column<TimeSpan>(type: "time", nullable: true),
                    Date = table.Column<DateTime>(type: "datetime", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    DogBreed = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LiveLocationEnabled = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__ServiceR__790F6CABD9E7C998", x => x.ServiceRequestID);
                    table.ForeignKey(
                        name: "FK__ServiceRe__DogWa__6DCC4D03",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                    table.ForeignKey(
                        name: "FK__ServiceRe__UserI__6EC0713C",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "WalkerReview",
                columns: table => new
                {
                    ReviewID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DogWalkerID = table.Column<int>(type: "int", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    ReviewText = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Timestamp = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__WalkerRe__74BC79AE43C20541", x => x.ReviewID);
                    table.ForeignKey(
                        name: "FK__WalkerRev__DogWa__719CDDE7",
                        column: x => x.DogWalkerID,
                        principalTable: "DogWalker",
                        principalColumn: "DogWalkerID");
                    table.ForeignKey(
                        name: "FK__WalkerRev__UserI__72910220",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "Comment",
                columns: table => new
                {
                    CommentID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PostID = table.Column<int>(type: "int", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    CommentContent = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())"),
                    LikesCount = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Comment__C3B4DFAAD757BB40", x => x.CommentID);
                    table.ForeignKey(
                        name: "FK__Comment__PostID__43D61337",
                        column: x => x.PostID,
                        principalTable: "ForumPost",
                        principalColumn: "PostID");
                    table.ForeignKey(
                        name: "FK__Comment__UserID__44CA3770",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "ForumPostTag",
                columns: table => new
                {
                    PostsPostId = table.Column<int>(type: "int", nullable: false),
                    TagsTagId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ForumPostTag", x => new { x.PostsPostId, x.TagsTagId });
                    table.ForeignKey(
                        name: "FK_ForumPostTag_ForumPost_PostsPostId",
                        column: x => x.PostsPostId,
                        principalTable: "ForumPost",
                        principalColumn: "PostID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ForumPostTag_Tag_TagsTagId",
                        column: x => x.TagsTagId,
                        principalTable: "Tag",
                        principalColumn: "TagID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ForumPostTags",
                columns: table => new
                {
                    PostsPostId = table.Column<int>(type: "int", nullable: true),
                    TagsTagId = table.Column<int>(type: "int", nullable: true),
                    PostId = table.Column<int>(type: "int", nullable: true),
                    TagId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.ForeignKey(
                        name: "FK_ForumPostTags_ForumPost_PostId",
                        column: x => x.PostId,
                        principalTable: "ForumPost",
                        principalColumn: "PostID");
                    table.ForeignKey(
                        name: "FK_ForumPostTags_Tag_TagId",
                        column: x => x.TagId,
                        principalTable: "Tag",
                        principalColumn: "TagID");
                });

            migrationBuilder.CreateTable(
                name: "Order",
                columns: table => new
                {
                    OrderID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OrderNumber = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    ShippingInfoID = table.Column<int>(type: "int", nullable: true),
                    Date = table.Column<DateTime>(type: "datetime", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    TotalAmount = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Order__C3905BAFD5DE5E5D", x => x.OrderID);
                    table.ForeignKey(
                        name: "FK__Order__ShippingI__5AB9788F",
                        column: x => x.ShippingInfoID,
                        principalTable: "UserShippingInformation",
                        principalColumn: "ShippingInfoID");
                    table.ForeignKey(
                        name: "FK__Order__UserID__59C55456",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "CommentLike",
                columns: table => new
                {
                    LikeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CommentID = table.Column<int>(type: "int", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    Timestamp = table.Column<DateTime>(type: "datetime", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__CommentL__A2922CF4DED4785D", x => x.LikeID);
                    table.ForeignKey(
                        name: "FK__CommentLi__Comme__489AC854",
                        column: x => x.CommentID,
                        principalTable: "Comment",
                        principalColumn: "CommentID");
                    table.ForeignKey(
                        name: "FK__CommentLi__UserI__498EEC8D",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "OrderItem",
                columns: table => new
                {
                    OrderItemID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OrderID = table.Column<int>(type: "int", nullable: true),
                    ProductID = table.Column<int>(type: "int", nullable: true),
                    Quantity = table.Column<int>(type: "int", nullable: true),
                    Subtotal = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OrderIte__57ED06A10CF4F6C4", x => x.OrderItemID);
                    table.ForeignKey(
                        name: "FK__OrderItem__Order__5D95E53A",
                        column: x => x.OrderID,
                        principalTable: "Order",
                        principalColumn: "OrderID");
                    table.ForeignKey(
                        name: "FK__OrderItem__Produ__5E8A0973",
                        column: x => x.ProductID,
                        principalTable: "Product",
                        principalColumn: "ProductID");
                });

            migrationBuilder.CreateTable(
                name: "Payment",
                columns: table => new
                {
                    PaymentID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OrderID = table.Column<int>(type: "int", nullable: true),
                    PaymentMethod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    TransactionID = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Status = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    Amount = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Payment__9B556A581D06CA63", x => x.PaymentID);
                    table.ForeignKey(
                        name: "FK__Payment__OrderID__6166761E",
                        column: x => x.OrderID,
                        principalTable: "Order",
                        principalColumn: "OrderID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_City_CountryID",
                table: "City",
                column: "CountryID");

            migrationBuilder.CreateIndex(
                name: "IX_Comment_PostID",
                table: "Comment",
                column: "PostID");

            migrationBuilder.CreateIndex(
                name: "IX_Comment_UserID",
                table: "Comment",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_CommentLike_CommentID",
                table: "CommentLike",
                column: "CommentID");

            migrationBuilder.CreateIndex(
                name: "IX_CommentLike_UserID",
                table: "CommentLike",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_DogWalker_CityID",
                table: "DogWalker",
                column: "CityID");

            migrationBuilder.CreateIndex(
                name: "IX_DogWalker_UserID",
                table: "DogWalker",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteWalker_DogWalkerID",
                table: "FavoriteWalker",
                column: "DogWalkerID");

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteWalker_UserID",
                table: "FavoriteWalker",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPost_UserID",
                table: "ForumPost",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTag_TagsTagId",
                table: "ForumPostTag",
                column: "TagsTagId");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTags_PostId",
                table: "ForumPostTags",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTags_TagId",
                table: "ForumPostTags",
                column: "TagId");

            migrationBuilder.CreateIndex(
                name: "IX_Order_ShippingInfoID",
                table: "Order",
                column: "ShippingInfoID");

            migrationBuilder.CreateIndex(
                name: "IX_Order_UserID",
                table: "Order",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItem_OrderID",
                table: "OrderItem",
                column: "OrderID");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItem_ProductID",
                table: "OrderItem",
                column: "ProductID");

            migrationBuilder.CreateIndex(
                name: "IX_Payment_OrderID",
                table: "Payment",
                column: "OrderID");

            migrationBuilder.CreateIndex(
                name: "IX_Product_ProductTypeID",
                table: "Product",
                column: "ProductTypeID");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledService_DogWalkerID",
                table: "ScheduledService",
                column: "DogWalkerID");

            migrationBuilder.CreateIndex(
                name: "IX_ScheduledService_UserID",
                table: "ScheduledService",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceRequest_DogWalkerID",
                table: "ServiceRequest",
                column: "DogWalkerID");

            migrationBuilder.CreateIndex(
                name: "IX_ServiceRequest_UserID",
                table: "ServiceRequest",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_User_CityID",
                table: "User",
                column: "CityID");

            migrationBuilder.CreateIndex(
                name: "IX_UserRole_RoleID",
                table: "UserRole",
                column: "RoleID");

            migrationBuilder.CreateIndex(
                name: "IX_UserRole_UserID",
                table: "UserRole",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_UserShippingInformation_UserID",
                table: "UserShippingInformation",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_WalkerReview_DogWalkerID",
                table: "WalkerReview",
                column: "DogWalkerID");

            migrationBuilder.CreateIndex(
                name: "IX_WalkerReview_UserID",
                table: "WalkerReview",
                column: "UserID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CommentLike");

            migrationBuilder.DropTable(
                name: "DogWalkerAvailability");

            migrationBuilder.DropTable(
                name: "DogWalkerLocation");

            migrationBuilder.DropTable(
                name: "FavoriteWalker");

            migrationBuilder.DropTable(
                name: "ForumPostTag");

            migrationBuilder.DropTable(
                name: "ForumPostTags");

            migrationBuilder.DropTable(
                name: "OrderItem");

            migrationBuilder.DropTable(
                name: "Payment");

            migrationBuilder.DropTable(
                name: "ScheduledService");

            migrationBuilder.DropTable(
                name: "ServiceRequest");

            migrationBuilder.DropTable(
                name: "UserRole");

            migrationBuilder.DropTable(
                name: "WalkerReview");

            migrationBuilder.DropTable(
                name: "Comment");

            migrationBuilder.DropTable(
                name: "Tag");

            migrationBuilder.DropTable(
                name: "Product");

            migrationBuilder.DropTable(
                name: "Order");

            migrationBuilder.DropTable(
                name: "Role");

            migrationBuilder.DropTable(
                name: "DogWalker");

            migrationBuilder.DropTable(
                name: "ForumPost");

            migrationBuilder.DropTable(
                name: "ProductType");

            migrationBuilder.DropTable(
                name: "UserShippingInformation");

            migrationBuilder.DropTable(
                name: "User");

            migrationBuilder.DropTable(
                name: "City");

            migrationBuilder.DropTable(
                name: "Country");
        }
    }
}
