using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IDogWalkerService : ICRUDService<DogWalkerDto, DogWalkerSearchObject, DogWalkerInsertRequest, DogWalkerInsertRequest>
    {
        Task<DogWalkerDto> Approve(int dogWalkerId);

        Task<DogWalkerDto> Reject(int dogWalkerId);
        Task<DogWalkerDto> CancelApplication(int dogWalkerId);

        Task<List<string>> AllowedActions(int dogWalkerId);
        int CalculateFinishedServiceRequests(int dogWalkerId);
        Task<List<DogWalkerDto>> GetDogWalkersWithMostReviewsFirst();
        Task<List<DogWalkerDto>> GetDogWalkersWithMostFinishedServicesFirst();
    }
}
