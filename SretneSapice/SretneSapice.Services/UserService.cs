using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class UserService : BaseCRUDService<UserDto, User, UserSearchObject, UserInsertRequest, UserUpdateRequest>, IUserService
    {

        public UserService(_180148Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(User entity, UserInsertRequest insert)
        {
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);
        }

        public override async Task BeforeUpdate(User entity, UserUpdateRequest update)
        {
            if (update.Password != null)
            {
                entity.PasswordSalt = GenerateSalt();
                entity.PasswordHash = GenerateHash(entity.PasswordSalt, update.Password);
            }
        }

        private string GenerateHash(string salt, string password)
        {
            var src = Convert.FromBase64String(salt);
            var bytes = Encoding.Unicode.GetBytes(password);
            var dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            var algorithm = HashAlgorithm.Create("SHA1");
            var inArray = algorithm?.ComputeHash(dst);
            return Convert.ToBase64String(inArray!);
        }

        private static string GenerateSalt()
        {
            var provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            if (search?.isRoleIncluded == true)
            {
                query = query.Include("UserRoles.Role");
            }
            return base.AddInclude(query, search);
        }

        public async Task<UserDto?> Login(string username, string password)
        {
            var entity = await _context.Users.Include("UserRoles.Role").FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
                return null;

            var hash = GenerateHash(entity.PasswordSalt, password);

            if(hash != entity.PasswordHash)
            {
                return null;
            }

            return _mapper.Map<UserDto>(entity);
        }

        public async Task<UserDto> Register(UserInsertRequest newUser)
        {
            var userRole = await _context.Roles.FirstOrDefaultAsync(x => x.Name == "User");

            if (await _context.Users.AnyAsync(x => x.Username.Equals(newUser.Username)))
            {
                throw new Exception("Username is taken!");
            }

            var user = new User
            {
                Name = newUser.Name,
                Surname = newUser.Surname,
                Email = newUser.Email,
                Phone = newUser.Phone,
                Username = newUser.Username,
                CityId = newUser.CityID
            };

            var salt = GenerateSalt();
            user.PasswordSalt = salt;
            user.PasswordHash = GenerateHash(salt, newUser.Password);

            await _context.AddAsync(user);
            await _context.SaveChangesAsync();

            var defaultRoleForNewUser = new UserRole
            {
                UserId = user.UserId,
                RoleId = userRole.RoleId,
                DateOfChange = DateTime.Now
            };

            await _context.AddAsync(defaultRoleForNewUser);
            await _context.SaveChangesAsync();

            return _mapper.Map<User, UserDto>(user);
        }
    }
}
