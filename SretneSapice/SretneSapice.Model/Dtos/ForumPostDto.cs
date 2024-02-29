using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class ForumPostDto
    {
        public int PostId { get; set; }
        public int? UserId { get; set; }
        public string Title { get; set; } = null!;
        public string PostContent { get; set; } = null!;
        public DateTime? Timestamp { get; set; }
        public byte[]? Photo { get; set; }
        public byte[]? PhotoThumb { get; set; }
        public int? LikesCount { get; set; }

        public virtual ICollection<CommentDto> Comments { get; } = new List<CommentDto>();

        public virtual UserDto? User { get; set; }

        public virtual ICollection<TagDto> Tags { get; } = new List<TagDto>();
    }
}
