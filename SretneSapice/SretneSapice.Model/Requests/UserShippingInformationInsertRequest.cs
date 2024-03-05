using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class UserShippingInformationInsertRequest
    {
        public string? Address { get; set; }

        public string? City { get; set; }

        public string? Zipcode { get; set; }

        public string? Phone { get; set; }
    }
}
