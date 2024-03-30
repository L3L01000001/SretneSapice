using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IServiceRequestService : ICRUDService<ServiceRequestDto, BaseSearchObject, ServiceRequestInsertRequest, ServiceRequestInsertRequest>
    {
        Task AcceptServiceRequest(int serviceRequestId);
        Task RejectServiceRequest(int serviceRequestId);
        Task FinishServiceRequest(int serviceRequestId);
        Task<bool> IsScheduledServiceTime(int serviceId);
        Task UpdateLiveLocationEnabled(int serviceId, bool enableLiveLocation);
    }
}
