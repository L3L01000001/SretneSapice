using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class ProductDto
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
        public string? Brand { get; set; }
        public int ProductTypeID { get; set; }
        public byte[] ProductPhoto { get; set; }
        public byte[] ProductPhotoThumb { get; set; }
        public bool? Status { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public virtual ProductTypeDto? ProductType { get; set; }
    }
}