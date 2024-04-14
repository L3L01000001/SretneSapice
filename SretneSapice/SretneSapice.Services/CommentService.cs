using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
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
    public class CommentService : BaseCRUDService<CommentDto, Comment, BaseSearchObject, CommentInsertRequest, CommentUpdateRequest> , ICommentService
    {
        public CommentService(_180148Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<CommentDto> Insert(CommentInsertRequest insertRequest)
        {
            var commentEntity = _mapper.Map<Comment>(insertRequest);

            commentEntity.Timestamp = DateTime.Now;

            commentEntity.LikesCount = 0;

            await _context.Comments.AddAsync(commentEntity);
            await _context.SaveChangesAsync();

            var post = await _context.ForumPosts.FindAsync(insertRequest.PostId);
            if (post != null)
            {
                var factory = new ConnectionFactory { HostName = "localhost" };
                using var connection = factory.CreateConnection();
                using var channel = connection.CreateModel();

                string message = $"{post.User.Name} received a new comment on '{post.Title}' post";

                var body = Encoding.UTF8.GetBytes(message);

                channel.BasicPublish(exchange: string.Empty,
                                     routingKey: "comments",
                                     basicProperties: null,
                                     body: body);
            }

            return _mapper.Map<CommentDto>(commentEntity);
        }

        public override async Task<CommentDto> Update(int id, CommentUpdateRequest updateRequest)
        {
            var comment = await _context.Comments.FindAsync(id);
            if (comment == null)
            {
                return null; 
            }

            comment.CommentContent = updateRequest.CommentContent;

            await _context.SaveChangesAsync();

            return _mapper.Map<CommentDto>(comment);
        }

        public override async Task<CommentDto> HardDelete(int commentId)
        {
            var comment = await _context.Comments.FindAsync(commentId);
            if (comment == null)
            {
                throw new Exception("Comment with this ID does not exist!");
            }

            _context.Comments.Remove(comment);

            await _context.SaveChangesAsync();

            return await GetById(commentId);
        }

        public async Task UpdateCommentLikesCount(int commentId)
        {
            var comment = await _context.Comments.FindAsync(commentId);

            if (comment != null)
            {
                var likesCount = await _context.CommentLikes.CountAsync(cl => cl.CommentId == commentId);

                comment.LikesCount = likesCount;

                await _context.SaveChangesAsync();
            }
        }
    }
}
