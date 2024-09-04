using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class ToDo4924InsertRequest
    {
        public string? NazivAktivnosti { get; set; }
        public string? OpisAktivnosti { get; set; }
        public DateTime? DatumIzvrsenja { get; set; }
        public string? StatusAktivnosti { get; set; }
        public int UserId { get; set; }

    }
}
