using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Helpers
{
    public static class StatusHelper<TDb> where TDb : class
    {
        public static void SetStatus(TDb? entity, bool status)
        {
            var property = entity?.GetType().GetProperty("Status");

            property?.SetValue(entity, status);
        }
    }
}
