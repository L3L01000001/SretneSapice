using AutoMapper;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch>,
        ICRUDService<T, TSearch, TInsert, TUpdate> where TDb : class where T : class where TSearch : BaseSearchObject
        where TInsert : class where TUpdate : class
    {
        public BaseCRUDService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb db, TInsert insert)
        {

        }

        public virtual async Task BeforeUpdate(TDb db, TUpdate update)
        {

        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            var createdDateProperty = typeof(TDb).GetProperty("CreatedDate");
            if (createdDateProperty != null && createdDateProperty.PropertyType == typeof(DateTime?))
            {
                if ((DateTime?)createdDateProperty.GetValue(entity) == null)
                {
                    createdDateProperty.SetValue(entity, DateTime.Now);
                }
            }

            set.Add(entity);

            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            if (entity is null)
                throw new InvalidOperationException();

            _mapper.Map(update, entity);

            var updatedDateProperty = typeof(TDb).GetProperty("UpdatedDate");
            if (updatedDateProperty != null && updatedDateProperty.PropertyType == typeof(DateTime?))
            {
                if ((DateTime?)updatedDateProperty.GetValue(entity) == null)
                {
                    updatedDateProperty.SetValue(entity, DateTime.Now);
                }
            }

            await BeforeUpdate(entity, update);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }
    }
}
