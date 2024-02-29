using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public int? OrderId { get; set; }

        public string? OrderNumber { get; set; }
        public DateTime? Date { get; set; }

        public string? Status { get; set; }

    }
}
