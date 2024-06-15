import 'dart:convert';

import 'package:sretnesapice_mobile/models/forum_post.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class ForumPostProvider extends BaseProvider<ForumPost> {
  ForumPostProvider() : super("ForumPosts");

  Future<List<ForumPost>> getForumPostsByNewest() async {
    var url = "$totalUrl/Newest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<ForumPost>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<ForumPost>> getForumPostsByOldest() async {
    var url = "$totalUrl/Oldest";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<ForumPost>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<ForumPost>> getForumPostsByMostPopular() async {
    var url = "$totalUrl/Mostpopular";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<ForumPost>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  @override
  ForumPost fromJson(data) {
    return ForumPost.fromJson(data);
  }
}
