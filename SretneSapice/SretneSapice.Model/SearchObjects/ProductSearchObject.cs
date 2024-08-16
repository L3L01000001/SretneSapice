using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class ProductSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public bool? Top5 { get; set; }
        public bool? Newest { get; set; }
        public bool? PriceLtoH { get; set; }
        public bool? PriceHtoL { get; set; }
    }
}
