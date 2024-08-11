using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class ReportService : IReportService
    {
        protected readonly _180148Context _context;
        protected readonly IMapper mapper;

        public ReportService(_180148Context context, IMapper mapper)
        {
            this.mapper = mapper;
            this._context = context;
        }

        public async Task<int> GetTotalRequests(ReportSearchObject search)
        {
            return await _context.ServiceRequests.CountAsync(r => r.Date >= search.DateFrom && r.Date <= search.DateTo);
        }

        public async Task<List<RequestsByStatusDto>> GetStatusBreakdown(ReportSearchObject search)
        {
            return await _context.ServiceRequests
                .Where(r => r.Date >= search.DateFrom && r.Date <= search.DateTo)
                .GroupBy(r => r.Status)
                .Select(g => new RequestsByStatusDto
                {
                    Status = g.Key,
                    Count = g.Count()
                })
                .ToListAsync();
        }
    }
}
