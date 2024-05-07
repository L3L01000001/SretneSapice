using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class DogWalkerDto
    {
        public int DogWalkerId { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string? FullName => $"{Name} {Surname}";
        public int Age { get; set; }
        public int? CityId { get; set; }
        public string Phone { get; set; }
        public string Experience { get; set; }
        public byte[]? DogWalkerPhoto { get; set; }
        public byte[]? DogWalkerPhotoThumb { get; set; }
        public int? Rating { get; set; }

        public bool? IsApproved { get; set; }

        public string Status { get; set; }
        public UserDto? User { get; set; }
        public virtual CityDto? City { get; set; }
        public virtual ICollection<ServiceRequestDto> ServiceRequests { get; } = new List<ServiceRequestDto>();
    }
}
