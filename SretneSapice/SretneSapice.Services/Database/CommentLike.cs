using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class CommentLike
{
    public int LikeId { get; set; }

    public int? CommentId { get; set; }

    public int? UserId { get; set; }

    public DateTime? Timestamp { get; set; }

    public virtual Comment? Comment { get; set; }

    public virtual User? User { get; set; }
}
