using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.Database
{
    [PrimaryKey(nameof(PostsPostId), nameof(TagsTagId))]
    public partial class ForumPostTag
    {
        // Composite key properties
        public int PostsPostId { get; set; }
        public int TagsTagId { get; set; }

        public int? PostId { get; set; }
        public int? TagId { get; set; }

        // Navigation properties
        public virtual ForumPost? ForumPost { get; set; }
        public virtual Tag? Tag { get; set; }
    }
}
