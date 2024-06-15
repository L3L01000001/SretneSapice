using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class fixForumPostTags : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ForumPostTags");

            migrationBuilder.AddColumn<int>(
                name: "PostId",
                table: "ForumPostTag",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "TagId",
                table: "ForumPostTag",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PostId",
                table: "ForumPostTag");

            migrationBuilder.DropColumn(
                name: "TagId",
                table: "ForumPostTag");

            migrationBuilder.CreateTable(
                name: "ForumPostTags",
                columns: table => new
                {
                    PostId = table.Column<int>(type: "int", nullable: true),
                    TagId = table.Column<int>(type: "int", nullable: true),
                    PostsPostId = table.Column<int>(type: "int", nullable: true),
                    TagsTagId = table.Column<int>(type: "int", nullable: true)
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

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTags_PostId",
                table: "ForumPostTags",
                column: "PostId");

            migrationBuilder.CreateIndex(
                name: "IX_ForumPostTags_TagId",
                table: "ForumPostTags",
                column: "TagId");
        }
    }
}
