using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Model.Requests
{
    public class DogWalkerInsertRequest
    {
        public string Name { get; set; }
        public string Surname { get; set; }
        public int Age { get; set; }
        public string Phone { get; set; }
        public int CityId { get; set; }
        public string Experience { get; set; }
        public byte[]? DogWalkerPhoto { get; set; }
        public byte[]? DogWalkerPhotoThumb { get; set; }
    }
}
