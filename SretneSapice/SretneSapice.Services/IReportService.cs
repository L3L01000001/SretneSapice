using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IReportService
    {
        Task<int> GetTotalRequests(ReportSearchObject search);
        Task<List<RequestsByStatusDto>> GetStatusBreakdown(ReportSearchObject search);
    }
}
