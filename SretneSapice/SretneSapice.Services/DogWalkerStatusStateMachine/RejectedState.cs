using AutoMapper;
using SretneSapice.Model.Dtos;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services.DogWalkerStatusStateMachine
{
    public class RejectedState : BaseState
    {
        public RejectedState(IServiceProvider serviceProvider, _180148Context context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }
        public override async Task Reject()
        {
            CurrentEntity.Status = "Rejected";
            CurrentEntity.IsApproved = false;

            await _context.SaveChangesAsync();
        }

        public override List<string> AllowedActions()
        {
            return new List<string> { "Reject" };
        }
    }
}
