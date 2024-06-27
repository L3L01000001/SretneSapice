using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class newPrimaryKey : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddPrimaryKey(
                name: "PK_DogWalkerAvailability",
                table: "DogWalkerAvailability",
                columns: new[] { "DogWalkerId", "Date", "StartTime", "EndTime" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_DogWalkerAvailability",
                table: "DogWalkerAvailability");
        }
    }
}
