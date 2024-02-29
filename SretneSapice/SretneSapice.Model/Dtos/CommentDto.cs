using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class CommentDto
    {
        public int CommentId { get; set; }
        public int? PostId { get; set; }
        public int? UserId { get; set; }
        public string CommentContent { get; set; } = null!;
        public DateTime? Timestamp { get; set; }
        public int? LikesCount { get; set; }

        public virtual ICollection<CommentLikeDto> CommentLikes { get; } = new List<CommentLikeDto>();

        public virtual ForumPostDto? Post { get; set; }

        public virtual UserDto? User { get; set; }
    }
}
