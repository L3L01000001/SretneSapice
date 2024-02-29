using SretneSapice.Model.Dtos;
using SretneSapice.Services.Database;
using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SretneSapice.Model.Requests;

namespace SretneSapice.Services.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<User, UserDto>();
            CreateMap<UserInsertRequest, User>();
            CreateMap<UserUpdateRequest, User>();

            CreateMap<ProductType, ProductTypeDto>();

            CreateMap<Product, ProductDto>();
            CreateMap<ProductInsertRequest, Product>();
            CreateMap<ProductUpdateRequest, Product>(); 

            CreateMap<UserRole, UserRoleDto>();

            CreateMap<Role, RoleDto>();

            CreateMap<City, CityDto>();

            CreateMap<Country, CountryDto>();

            CreateMap<Tag, TagDto>().ReverseMap();
            CreateMap<TagInsertRequest, Tag>().ReverseMap();

            CreateMap<Comment, CommentDto>();
            CreateMap<CommentInsertRequest, Comment>();

            CreateMap<CommentLike, CommentLikeDto>();

            CreateMap<ForumPost, ForumPostDto>();
            CreateMap<ForumPostInsertRequest, ForumPost>();

            CreateMap<List<string>, ICollection<Tag>>()
            .ConvertUsing<StringListToTagCollectionConverter>();
        }
    }

    public class StringListToTagCollectionConverter : ITypeConverter<List<string>, ICollection<Tag>>
    {
        private readonly _180148Context _context;

        public StringListToTagCollectionConverter(_180148Context context)
        {
            _context = context;
        }

        public ICollection<Tag> Convert(List<string> source, ICollection<Tag> destination, ResolutionContext context)
        {
            var tagEntities = new List<Tag>();

            foreach (var tagName in source)
            {
                var existingTag = _context.Tags.FirstOrDefault(t => t.TagName == tagName);
                if (existingTag != null)
                {
                    tagEntities.Add(existingTag);
                }
                else
                {
                    var newTag = new Tag { TagName = tagName };
                    tagEntities.Add(newTag);
                }
            }

            return tagEntities;
        }
    }
}
