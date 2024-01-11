using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ProductInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public string? Code { get; set; }

        public decimal Price { get; set; }

        public int StockQuantity { get; set; }

        public int? ProductTypeId { get; set; }

        public string? Brand { get; set; }

        public byte[]? ProductPhoto { get; set; }

        public byte[]? ProductPhotoThumb { get; set; }
    }
}
