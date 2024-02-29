﻿using SretneSapice.Model.Dtos;
using SretneSapice.Model.Requests;
using SretneSapice.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SretneSapice.Services
{
    public interface IForumPostService : ICRUDService<ForumPostDto, ForumPostSearchObject, ForumPostInsertRequest, ForumPostUpdateRequest>
    {
        Task<List<ForumPostDto>> GetForumPostsByNewestAsync();
        Task<List<ForumPostDto>> GetForumPostsByOldestAsync();
        Task<List<ForumPostDto>> GetForumPostsByMostPopularAsync();
    }
}
