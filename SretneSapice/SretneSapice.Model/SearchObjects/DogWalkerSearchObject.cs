using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class DogWalkerSearchObject : BaseSearchObject
    {
        public string? FullName { get; set; }
        public bool? isApproved { get; set; }
        public int? Rating { get; set; }
        public bool? BestRating { get; set; }
        public int? CityId { get; set; }
        public bool? Top5 { get; set; }
    }
}
