using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class CityDto
    {
        public int CityID { get; set; }
        public string? Name { get; set; }
        public int CountryId { get; set; }
        public virtual CountryDto Country { get; set; }
    }
}
