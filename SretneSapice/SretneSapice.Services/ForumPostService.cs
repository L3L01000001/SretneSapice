using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SretneSapice.Model;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public class ForumPostService : BaseCRUDService<ForumPostDto, ForumPost, ForumPostSearchObject, ForumPostInsertRequest, ForumPostUpdateRequest>, IForumPostService
    {
        public long LoggedInUserId;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ForumPostService(_180148Context context, IMapper mapper,
            IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
            ClaimsIdentity user = (ClaimsIdentity)_httpContextAccessor.HttpContext.User.Identity;
            LoggedInUserId = Convert.ToUInt32(user.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        }
        public override async Task<ForumPostDto> Insert(ForumPostInsertRequest insertRequest)
        {
            var existingTags = new List<Tag>();
            var newTags = new List<string>();

            if (insertRequest.Tags != null && insertRequest.Tags.Any())
            {
                foreach (var tagName in insertRequest.Tags)
                {
                    var existingTag = await _context.Tags.FirstOrDefaultAsync(t => t.TagName == tagName);
                    if (existingTag != null)
                    {
                        existingTags.Add(existingTag); 
                    }
                    else
                    {
                        newTags.Add(tagName);
                    }
                }
            }

            var forumPostEntity = _mapper.Map<ForumPost>(insertRequest);

            forumPostEntity.UserId = (int?)LoggedInUserId;

            foreach (var existingTag in existingTags)
            {
                forumPostEntity.Tags.Add(existingTag);
            }

            foreach (var newTagName in newTags)
            {
                var newTagEntity = new Tag { TagName = newTagName };
                forumPostEntity.Tags.Add(newTagEntity);
            }

            await _context.ForumPosts.AddAsync(forumPostEntity);
            await _context.SaveChangesAsync();

            foreach (var tag in forumPostEntity.Tags)
            {
                _context.ForumPostTags.Add(new ForumPostTag { PostsPostId = forumPostEntity.PostId, TagsTagId = tag.TagId });
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<ForumPostDto>(forumPostEntity);
        }

        public override async Task<ForumPostDto> HardDelete(int postId)
        {
            var postToDelete = await _context.ForumPosts.FindAsync(postId);
            if (postToDelete == null)
            {
                throw new Exception("Post with this ID does not exist!");
            }

            _context.ForumPosts.Remove(postToDelete);

            var postTags = await _context.ForumPostTags.Where(pt => pt.PostsPostId == postId).ToListAsync();
            _context.ForumPostTags.RemoveRange(postTags);

            await _context.SaveChangesAsync();

            return await GetById(postId);
        }

        public override IQueryable<ForumPost> AddInclude(IQueryable<ForumPost> query, ForumPostSearchObject? search = null)
        {
            query = query.Include(x => x.Tags).Include(x => x.Comments).Include(x => x.User);
            return base.AddInclude(query, search);
        }

        public override IQueryable<ForumPost> AddFilter(IQueryable<ForumPost> query, ForumPostSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.PostContent))
            {
                filteredQuery = filteredQuery.Where(x => x.PostContent.Contains(search.PostContent));
            }

            return filteredQuery;
        }

        public async Task<PagedResult<ForumPostDto>> GetForumPostsByNewestAsync()
        {
            var query = _context.ForumPosts.OrderByDescending(p => p.Timestamp).AsQueryable();

            PagedResult<ForumPostDto> result = new PagedResult<ForumPostDto>();

            result.Count = await query.CountAsync();

            var forumPosts = await query.ToListAsync();

            result.Result = _mapper.Map<List<ForumPostDto>>(forumPosts);

            return result;
        }

        public async Task<PagedResult<ForumPostDto>> GetForumPostsByOldestAsync()
        {
            var query = _context.ForumPosts.OrderBy(p => p.Timestamp).AsQueryable();

            PagedResult<ForumPostDto> result = new PagedResult<ForumPostDto>();

            result.Count = await query.CountAsync();

            var forumPosts = await query.ToListAsync();

            result.Result = _mapper.Map<List<ForumPostDto>>(forumPosts);

            return result;
        }

        public async Task<PagedResult<ForumPostDto>> GetForumPostsByMostPopularAsync()
        {
            var query = _context.ForumPosts.OrderByDescending(p => p.LikesCount).AsQueryable();

            PagedResult<ForumPostDto> result = new PagedResult<ForumPostDto>();

            result.Count = await query.CountAsync();

            var forumPosts = await query.ToListAsync();

            result.Result = _mapper.Map<List<ForumPostDto>>(forumPosts);

            return result;
        }
    }
}
