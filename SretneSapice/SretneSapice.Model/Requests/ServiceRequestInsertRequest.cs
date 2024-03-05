using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ServiceRequestInsertRequest
    {
        public int? DogWalkerId { get; set; }

        public int? UserId { get; set; }

        public TimeSpan? StartTime { get; set; }

        public TimeSpan? EndTime { get; set; }

        public DateTime? Date { get; set; }
        public string? Status { get; set; }
        public string DogBreed { get; set; }
    }
}
