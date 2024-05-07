using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class UserShippingInformationDto
    {
        public int ShippingInfoId { get; set; }

        public int? UserId { get; set; }
        public string? Address { get; set; }

        public string? City { get; set; }

        public string? Zipcode { get; set; }

        public string? Phone { get; set; }

        public virtual ICollection<OrderDto> Orders { get; } = new List<OrderDto>();

        public virtual UserDto? User { get; set; }
    }
}
