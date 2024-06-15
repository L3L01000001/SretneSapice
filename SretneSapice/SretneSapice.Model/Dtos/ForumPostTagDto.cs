using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class ForumPostTagDto
    {
        public int? PostsPostId { get; set; }
        public int? TagsTagId { get; set; }
        public virtual TagDto? Tag { get; set; }
    }
}
