using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ReportsController : Controller
    {
        readonly IReportService reportService;
        readonly ILogger<ReportsController> logger;

        public ReportsController(ILogger<ReportsController> logger, IReportService reportService)
        {
            this.reportService = reportService;
        }

        [HttpGet("total")]
        public async Task<int> GetTotalRequests([FromQuery] ReportSearchObject search = null)
        {
            return await reportService.GetTotalRequests(search);
        }

        [HttpGet("status-breakdown")]
        public async Task<List<RequestsByStatusDto>> GetStatusBreakdown([FromQuery] ReportSearchObject search = null)
        {
            return await reportService.GetStatusBreakdown(search);
        }

    }
}
