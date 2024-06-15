using System;
using System.Collections.Generic;

namespace SretneSapice.Services.Database;

public partial class Tag
{
    public int TagId { get; set; }

    public string? TagName { get; set; }

    public virtual ICollection<ForumPostTag> ForumPostTags { get; } = new List<ForumPostTag>();
}
