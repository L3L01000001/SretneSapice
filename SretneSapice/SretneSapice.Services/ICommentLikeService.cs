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
    public interface ICommentLikeService : IService<CommentLikeDto, BaseSearchObject>
    {
        Task<CommentLikeDto> LikeComment(int commentId, int userId);
        Task UnlikeComment(int commentId, int userId);
        Task<List<CommentLikeDto>> GetLikesForComment(int commentId);
    }
}
