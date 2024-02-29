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
        public int? PostsPostId { get; set; }
        public int? TagsTagId { get; set; }

        // Navigation properties
        public ForumPost? Post { get; set; }
        public Tag? Tag { get; set; }
    }
}
