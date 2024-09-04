using AutoMapper;
using Microsoft.EntityFrameworkCore;
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
    public class ToDo4924Service : BaseCRUDService<ToDo4924Dto, ToDo4924, ToDo4924SearchObject, ToDo4924InsertRequest, ToDo4924InsertRequest>, IToDo4924Service
    {
        public ToDo4924Service(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ToDo4924> AddInclude(IQueryable<ToDo4924> query, ToDo4924SearchObject? search = null)
        {
            query = query.Include(x => x.User);

            return base.AddInclude(query, search);
        }

        public override IQueryable<ToDo4924> AddFilter(IQueryable<ToDo4924> query, ToDo4924SearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.User))
            {
                query = query.Include(x => x.User).Where(x => x.User.Name.ToLower().Contains(search.User) || x.User.Surname.ToLower().Contains(search.User));
            }

            if (!string.IsNullOrWhiteSpace(search?.StatusAktivnosti))
            {
                query = query.Where(p => p.StatusAktivnosti == search.StatusAktivnosti);
            }

            if(search.DatumVazenja is not null)
            {
                query = query.Where(q => q.DatumIzvrsenja.Value.Date < search.DatumVazenja.Value.Date);
            }

            return base.AddFilter(query, search);
        }
    }
}
