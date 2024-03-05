using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Model.Dtos;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace SretneSapice.Services
{
    public class TagService : BaseCRUDService<TagDto, Tag, TagSearchObject, TagInsertRequest, TagInsertRequest>, ITagService
    {
        public TagService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
