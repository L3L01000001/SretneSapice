using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class CommentLikeDto
    {
        public int LikeId { get; set; }
        public int? CommentId { get; set; }
        public int? UserId { get; set; }
        public DateTime? Timestamp { get; set; }

        public virtual CommentDto? Comment { get; set; }

        public UserDto? User { get; set; }
    }
}
