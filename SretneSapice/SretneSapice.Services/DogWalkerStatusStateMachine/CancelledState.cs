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
    public class CancelledState : BaseState
    {
        public CancelledState(IServiceProvider serviceProvider, _180148Context context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }
        public override async Task CancelApplication()
        {
            CurrentEntity.Status = "Cancelled";
            CurrentEntity.IsApproved = false;

            await _context.SaveChangesAsync();
        }

        public override List<string> AllowedActions()
        {
            return new List<string> { "CancelApplication" };
        }
    }
}
