using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Comment
{
    public int CommentId { get; set; }

    public int? PostId { get; set; }

    public int? UserId { get; set; }

    public string CommentContent { get; set; } = null!;

    public DateTime? Timestamp { get; set; }

    public int? LikesCount { get; set; }

    public virtual ICollection<CommentLike> CommentLikes { get; } = new List<CommentLike>();

    public virtual ForumPost? Post { get; set; }

    public virtual User? User { get; set; }
}
