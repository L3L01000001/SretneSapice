using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.Database
{
    [PrimaryKey(nameof(ToDoId))]
    public partial class ToDo4924
    {
        public int ToDoId { get; set; }
        public string? NazivAktivnosti { get; set; }
        public string? OpisAktivnosti { get; set; }
        public DateTime? DatumIzvrsenja { get; set; }
        public string? StatusAktivnosti { get; set; }
        public int? UserId { get; set; }

        public virtual User? User { get; set; }

    }
}
