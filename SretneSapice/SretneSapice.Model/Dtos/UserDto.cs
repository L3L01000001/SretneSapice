using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class UserDto
    {
        public int UserId { get; set; }
        public string Name { get; set; }

        public string Surname { get; set; }
        public string? FullName => $"{Name} {Surname}";

        public string Email { get; set; }
        public string Phone { get; set; }

        public string Username { get; set; }

        public string Password { get; set; }

        public string ConfirmPassword { get; set; }
        public int CityID { get; set; }
        public byte[]? ProfilePhoto { get; set; }
        public bool? Status { get; set; }
        public virtual ICollection<UserRoleDto> UserRoles { get; } = new List<UserRoleDto>();

        public RoleDto? Role { get; set; }
        public virtual CityDto? City { get; set; }
    }
}
