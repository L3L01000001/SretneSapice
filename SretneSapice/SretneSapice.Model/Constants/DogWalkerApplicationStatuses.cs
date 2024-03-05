﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Constants
{
    public static class DogWalkerApplicationStatuses
    {
        public const string Pending = "Pending";

        public const string Approved = "Approved";

        public const string Rejected = "Rejected";

        public const string Cancelled = "Cancelled";

        public static readonly List<string> ListOfDogWalkerApplicationStatuses = new()
        {
            Pending, Approved, Rejected, Cancelled
        };
    }
}
