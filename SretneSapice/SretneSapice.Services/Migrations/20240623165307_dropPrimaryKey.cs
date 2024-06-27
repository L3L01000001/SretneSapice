using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class dropPrimaryKey : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK__DogWalke__A9F7DEBDFB5F1C93",
                table: "DogWalkerAvailability");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddPrimaryKey(
                name: "PK__DogWalke__A9F7DEBDFB5F1C93",
                table: "DogWalkerAvailability",
                columns: new[] { "DogWalkerId", "Date", "StartTime", "EndTime" });
        }
    }
}
