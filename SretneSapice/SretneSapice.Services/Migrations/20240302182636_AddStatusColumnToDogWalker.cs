using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddStatusColumnToDogWalker : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
            name: "Status",
            table: "DogWalker",
            nullable: false,
            defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
            name: "Status",
            table: "DogWalker");
        }
    }
}
