using SretneSapice.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IService<T, TSearch> where T : class where TSearch : class
    {
        Task<PagedResult<T>> GetAll(TSearch search = null);
        Task<T> GetById(int id);
    }
}
