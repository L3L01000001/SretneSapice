using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class UserRoleDto
    {
        public int UserRoleId { get; set; }

        public int? UserId { get; set; }

        public int? RoleId { get; set; }

        public DateTime? DateOfChange { get; set; }

        public virtual RoleDto? Role { get; set; }

    }
}
