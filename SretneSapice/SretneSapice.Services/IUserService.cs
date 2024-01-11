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
    public interface IUserService : ICRUDService<UserDto, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
      Task<UserDto?> Login(string username, string password);
       Task<UserDto> Register(UserInsertRequest newUser);
    }
}
