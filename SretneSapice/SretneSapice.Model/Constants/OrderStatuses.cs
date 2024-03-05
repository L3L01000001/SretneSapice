using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Constants
{
    public static class OrderStatuses
    {
        public const string InCart = "In Cart";

        public const string Pending = "Pending";

        public const string Completed = "Completed";

        public const string Cancelled = "Cancelled";

        public static readonly List<string> ListOfOrderStatuses = new()
        {
            InCart, Pending, Completed, Cancelled
        };
    }
}
