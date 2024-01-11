using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ProductUpdateRequest
    {
        public string? Name { get; set; }

        public string? Description { get; set; }

        public decimal? Price { get; set; }

        public int? StockQuantity { get; set; }

        public byte[]? ProductPhoto { get; set; }

        public byte[]? ProductPhotoThumb { get; set; }

    }
}
