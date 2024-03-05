using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class FavoriteWalkerInsertRequest
    {
        public int UserId { get; set; }
        public int DogWalkerId { get; set; }
    }
}
