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
    public class CommentLikeService : BaseService<CommentLikeDto, CommentLike, BaseSearchObject>, ICommentLikeService
    {
        public CommentLikeService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task LikeComment(int commentId, int userId)
        {
            var existingLike = await _context.CommentLikes
                .FirstOrDefaultAsync(cl => cl.CommentId == commentId && cl.UserId == userId);

            if (existingLike != null)
            {
                return;
            }

            var newLike = new CommentLike
            {
                CommentId = commentId,
                UserId = userId,
                Timestamp = DateTime.Now 
            };

            _context.CommentLikes.Add(newLike);
            await _context.SaveChangesAsync();

        }

        public async Task UnlikeComment(int commentId, int userId)
        {
            var existingLike = await _context.CommentLikes
                .FirstOrDefaultAsync(cl => cl.CommentId == commentId && cl.UserId == userId);

            if (existingLike != null)
            {
                _context.CommentLikes.Remove(existingLike);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<CommentLikeDto>> GetLikesForComment(int commentId)
        {
            var likes = await _context.CommentLikes
                .Where(cl => cl.CommentId == commentId)
                .ToListAsync();

            return _mapper.Map<List<CommentLikeDto>>(likes);
        }

    }
}
