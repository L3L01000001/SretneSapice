import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class ForumPostProvider extends BaseProvider<ForumPost> {
  ForumPostProvider() : super("ForumPosts");

  @override
  ForumPost fromJson(data) {
    return ForumPost.fromJson(data);
  }
}
