using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.SearchObjects
{
    public class ToDo4924SearchObject : BaseSearchObject
    {
        public string? User { get; set; }
        public DateTime? DatumVazenja { get; set; }
        public string? StatusAktivnosti { get; set; }
    }
}
