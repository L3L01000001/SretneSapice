import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class ForumPostProvider extends BaseProvider<ForumPost> {
  ForumPostProvider() : super("ForumPosts");

  Future<SearchResult<ForumPost>> getForumPostsByNewest() async {
    var url = "$totalUrl/Newest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<ForumPost>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  Future<SearchResult<ForumPost>> getForumPostsByOldest() async {
    var url = "$totalUrl/Oldest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<ForumPost>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  Future<SearchResult<ForumPost>> getForumPostsByMostPopular() async {
    var url = "$totalUrl/Mostpopular";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<ForumPost>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška!");
    }
  }

  @override
  ForumPost fromJson(data) {
    return ForumPost.fromJson(data);
  }
}
