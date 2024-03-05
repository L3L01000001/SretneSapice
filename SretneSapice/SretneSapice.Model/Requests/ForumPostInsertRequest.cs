using SretneSapice.Model.Dtos;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ForumPostInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Title { get; set; } = null!;

        public string? PostContent { get; set; }
        //public int? UserId { get; set; }

        public byte[]? Photo { get; set; }

        public byte[]? PhotoThumb { get; set; }

        public List<string>? Tags { get; set; }
    }
}
