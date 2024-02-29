using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace SretneSapice.Services.Database;

public partial class ForumPost
{
    public int PostId { get; set; }

    public int? UserId { get; set; }

    public string Title { get; set; } = null!;

    public string PostContent { get; set; } = null!;

    public DateTime? Timestamp { get; set; }

    public byte[]? Photo { get; set; }

    public byte[]? PhotoThumb { get; set; }

    public int? LikesCount { get; set; }

    public virtual ICollection<Comment> Comments { get; } = new List<Comment>();

    public virtual User? User { get; set; }

    [JsonIgnore]
    public virtual ICollection<Tag> Tags { get; } = new List<Tag>();
}
