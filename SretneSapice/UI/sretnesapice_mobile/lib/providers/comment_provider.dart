import 'package:sretnesapice_mobile/models/comment.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class CommentProvider extends BaseProvider<Comment> {
  CommentProvider() : super("Comments");

  @override
  Comment fromJson(data) {
    return Comment.fromJson(data);
  }
}
