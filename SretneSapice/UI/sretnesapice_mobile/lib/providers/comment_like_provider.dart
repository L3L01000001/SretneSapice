import 'dart:convert';

import 'package:sretnesapice_mobile/models/comment_like.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class CommentLikeProvider extends BaseProvider<CommentLike> {
  CommentLikeProvider() : super("api/CommentLikes");

  @override
  CommentLike fromJson(data) {
    return CommentLike.fromJson(data);
  }

  Future<void> likeComment(int commentId, int userId) async {
    var url = "$totalUrl/like?commentId=$commentId&userId=$userId";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.post(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Uspješno likean komentar!");
    } else {
      throw Exception('Greška');
    }
  }

  Future<void> unlikeComment(int commentId, int userId) async {
    var url = "$totalUrl/unlike?commentId=$commentId&userId=$userId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.put(
      uri,
      headers: headers
    );

    if (response.statusCode == 200) {
      print("Uspješno unlikean komentar!");
    } else {
      throw Exception('Greška!');
    }
  }
}
