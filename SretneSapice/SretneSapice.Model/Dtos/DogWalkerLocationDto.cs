﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Dtos
{
    public class DogWalkerLocationDto
    {
        public int DogWalkerId { get; set; }

        public DateTime Timestamp { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }

        public virtual DogWalkerDto DogWalker { get; set; } = null!;
    }
}
