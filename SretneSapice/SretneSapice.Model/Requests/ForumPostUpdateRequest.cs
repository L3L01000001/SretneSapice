using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ForumPostUpdateRequest
    {
        public string? PostContent { get; set; }
        public List<string>? Tags { get; set; }
    }
}
