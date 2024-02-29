using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class CommentInsertRequest
    {
        public int PostId { get; set; }
        public int UserId { get; set; }
        public string CommentContent { get; set; }
    }
}
