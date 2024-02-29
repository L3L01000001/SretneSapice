using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class addPrimaryKeyToForumPostTag : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ForumPostTag",
                columns: table => new
                {
                    PostsPostId = table.Column<int>(type: "int", nullable: false),
                    TagsTagId = table.Column<int>(type: "int", nullable: false),
                    PostId = table.Column<int>(type: "int", nullable: true),
                    TagId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    // Define composite primary key
                    table.PrimaryKey("PK_ForumPostTag", x => new { x.PostsPostId, x.TagsTagId });

                    // Define foreign key constraints
                    table.ForeignKey(
                        name: "FK_ForumPostTag_ForumPost_PostId",
                        column: x => x.PostId,
                        principalTable: "ForumPost",
                        principalColumn: "PostID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ForumPostTag_Tag_TagId",
                        column: x => x.TagId,
                        principalTable: "Tag",
                        principalColumn: "TagID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTag_PostId",
                table: "ForumPostTag",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTag_TagId",
                table: "ForumPostTag",
                column: "TagId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ForumPostTag");
        }
    }
}
