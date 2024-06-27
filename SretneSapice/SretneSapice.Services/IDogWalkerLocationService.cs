using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IDogWalkerLocationService : ICRUDService<DogWalkerLocationDto, BaseSearchObject, DogWalkerLocationInsertRequest, DogWalkerLocationInsertRequest>
    {
        Task<bool> DogWalkerExistsInTable(int dogWalkerId);
    }
}
