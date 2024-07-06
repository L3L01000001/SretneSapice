using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class UserUpdateRequest
    {
        public string? Name { get; set; }

        public string? Surname { get; set; }
        public string? Phone { get; set; }
        public string? Password { get; set; }

        public string? ConfirmPassword { get; set; }

        public bool? Status { get; set; }
        public byte[]? ProfilePhoto { get; set; }
    }
}
