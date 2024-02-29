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

        public async Task<CommentLikeDto> LikeComment(int commentId, int userId)
        {
            // Check if the user has already liked the comment
            var existingLike = await _context.CommentLikes
                .FirstOrDefaultAsync(cl => cl.CommentId == commentId && cl.UserId == userId);

            if (existingLike != null)
            {
                // User has already liked the comment, handle accordingly (e.g., return null or throw exception)
                return null;
            }

            // Create a new CommentLike entity
            var newLike = new CommentLike
            {
                CommentId = commentId,
                UserId = userId,
                Timestamp = DateTime.Now // Set the timestamp to the current time
            };

            // Add the new like to the database
            _context.CommentLikes.Add(newLike);
            await _context.SaveChangesAsync();

            // Map the new like to a DTO and return it
            return _mapper.Map<CommentLikeDto>(newLike);
        }

        public async Task UnlikeComment(int commentId, int userId)
        {
            // Find the existing like
            var existingLike = await _context.CommentLikes
                .FirstOrDefaultAsync(cl => cl.CommentId == commentId && cl.UserId == userId);

            if (existingLike != null)
            {
                // Remove the like from the database
                _context.CommentLikes.Remove(existingLike);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<CommentLikeDto>> GetLikesForComment(int commentId)
        {
            // Retrieve all likes for the specified comment
            var likes = await _context.CommentLikes
                .Where(cl => cl.CommentId == commentId)
                .ToListAsync();

            // Map the likes to DTOs and return the list
            return _mapper.Map<List<CommentLikeDto>>(likes);
        }

    }
}
