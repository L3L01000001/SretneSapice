using Microsoft.AspNetCore.Mvc;
using SretneSapice.Model.Dtos;
using SretneSapice.Model.SearchObjects;
using SretneSapice.Services;

namespace SretneSapice.Controllers
{
    [ApiController]
    public class CommentLikesController : BaseController<CommentLikeDto, BaseSearchObject>
    {
        private readonly ICommentLikeService _commentLikeService;
        private readonly ICommentService _commentService;
        public CommentLikesController(ICommentLikeService service, ICommentService commentService, ILogger<BaseController<CommentLikeDto, BaseSearchObject>> logger) : base(logger, service)
        {
            _commentLikeService = service;
            _commentService = commentService;
        }

        [HttpPost("like")]
        public async Task LikeComment(int commentId, int userId)
        {
            await _commentLikeService.LikeComment(commentId, userId);
            await _commentService.UpdateCommentLikesCount(commentId);
        }

        [HttpPut("unlike")]
        public async Task UnlikeComment(int commentId, int userId)
        {
            await _commentLikeService.UnlikeComment(commentId, userId);
            await _commentService.UpdateCommentLikesCount(commentId);
        }
    }
}
