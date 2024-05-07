using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public bool? isActive { get; set; }
        public bool? isRoleIncluded { get; set; }
        public string? Roles { get; set; }
    }
}
