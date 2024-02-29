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
    public interface ITagService : ICRUDService<TagDto, TagSearchObject, TagInsertRequest, TagInsertRequest>
    {
        Task<TagDto> GetTagByName(string tagName);
    }
}
