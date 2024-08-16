import 'dart:convert';

import 'package:sretnesapice_mobile/models/forum_post.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class ForumPostProvider extends BaseProvider<ForumPost> {
  ForumPostProvider() : super("ForumPosts");

  @override
  ForumPost fromJson(data) {
    return ForumPost.fromJson(data);
  }
}
