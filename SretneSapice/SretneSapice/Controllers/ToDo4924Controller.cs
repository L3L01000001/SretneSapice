using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ToDo4924Controller : BaseCRUDController<ToDo4924Dto, ToDo4924SearchObject, ToDo4924InsertRequest, ToDo4924InsertRequest>
    {
        public ToDo4924Controller(IToDo4924Service service, ILogger<BaseController<ToDo4924Dto, ToDo4924SearchObject>> logger) : base(logger, service)
        {
        }
    }
}
