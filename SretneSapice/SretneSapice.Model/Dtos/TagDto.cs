using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class TagDto
    {
        public int? TagId { get; set; }
        public string TagName { get; set; }

        public virtual ICollection<ForumPostDto> Posts { get; } = new List<ForumPostDto>();
    }
}
