using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class modifyServiceRequestTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EndTime",
                table: "ServiceRequest");

            migrationBuilder.DropColumn(
                name: "StartTime",
                table: "ServiceRequest");

            migrationBuilder.AddColumn<TimeSpan>(
                name: "EndTime",
                table: "ServiceRequest",
                type: "time",
                nullable: true);

            migrationBuilder.AddColumn<TimeSpan>(
                name: "StartTime",
                table: "ServiceRequest",
                type: "time",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "Date",
                table: "ServiceRequest",
                type: "date",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Date",
                table: "ServiceRequest");

            migrationBuilder.DropColumn(
                name: "EndTime",
                table: "ServiceRequest");

            migrationBuilder.DropColumn(
                name: "StartTime",
                table: "ServiceRequest");

            migrationBuilder.AddColumn<DateTime>(
                name: "EndTime",
                table: "ServiceRequest",
                type: "datetime",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "StartTime",
                table: "ServiceRequest",
                type: "datetime",
                nullable: true);
        }
    }
}
