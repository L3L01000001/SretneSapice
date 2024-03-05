using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class WalkerReviewDto
    {
        public int ReviewId { get; set; }

        public int? DogWalkerId { get; set; }

        public int? UserId { get; set; }

        public int Rating { get; set; }

        public string? ReviewText { get; set; }

        public DateTime? Timestamp { get; set; }

        public virtual DogWalkerDto? DogWalker { get; set; }

        public virtual UserDto? User { get; set; }
    }
}
