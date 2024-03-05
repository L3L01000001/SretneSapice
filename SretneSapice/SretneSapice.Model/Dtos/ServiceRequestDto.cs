using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class ServiceRequestDto
    {
        public int ServiceRequestId { get; set; }

        public int? DogWalkerId { get; set; }

        public int? UserId { get; set; }

        public TimeSpan? StartTime { get; set; }

        public TimeSpan? EndTime { get; set; }

        public DateTime? Date { get; set; }

        public string? Status { get; set; }
        public string DogBreed { get; set; }

        public virtual DogWalkerDto? DogWalker { get; set; }

        public virtual UserDto? User { get; set; }
    }
}
