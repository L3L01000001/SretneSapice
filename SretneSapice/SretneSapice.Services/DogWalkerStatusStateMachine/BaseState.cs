using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.DogWalkerStatusStateMachine
{
    public class BaseState
    {
        protected _180148Context _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, _180148Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public DogWalker CurrentEntity { get; set; }

        public virtual Task<DogWalkerDto> Insert(DogWalkerInsertRequest request)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task Approve()
        {
            throw new Exception("Not allowed");
        }

        public virtual Task Reject()
        {
            throw new Exception("Not allowed");
        }

        public virtual Task CancelApplication()
        {
            throw new Exception("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            if (_serviceProvider is null)
                throw new Exception("Invalid service provider!");
            switch (stateName)
            {
                case "Pending":
                    return _serviceProvider.GetService<PendingState>()!;
                case "Approved":
                    return _serviceProvider.GetService<ApprovedState>()!;
                case "Rejected":
                    return _serviceProvider.GetService<RejectedState>()!;
                case "Cancelled":
                    return _serviceProvider.GetService<CancelledState>()!;
                default:
                    throw new Exception("Not supported");
            }
        }

        public virtual List<string> AllowedActions()
        {
            return new List<string>();
        }

    }
}
