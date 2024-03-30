using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SretneSapice.Services.Migrations
{
    /// <inheritdoc />
    public partial class addLiveLocationPropToServiceRequest : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "Rating",
                table: "WalkerReview",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "LiveLocationEnabled",
                table: "ServiceRequest",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LiveLocationEnabled",
                table: "ServiceRequest");

            migrationBuilder.AlterColumn<int>(
                name: "Rating",
                table: "WalkerReview",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");
        }
    }
}
