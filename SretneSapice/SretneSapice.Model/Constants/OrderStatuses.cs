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

        public const string Paid = "Paid";

        public const string Processing = "Processing";

        public const string Shipped = "Shipped";

        public const string Cancelled = "Cancelled";

        public static readonly List<string> ListOfOrderStatuses = new()
        {
            InCart, Paid, Processing, Shipped, Cancelled
        };
    }
}
