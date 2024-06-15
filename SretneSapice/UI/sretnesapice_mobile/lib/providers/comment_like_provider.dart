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
    var url = "$totalUrl/like";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.post(uri, headers: headers, body: jsonEncode({'commentId': commentId, 'userId': userId}),);

    if (isValidResponseCode(response)) {
      notifyListeners();
    } else {
      throw Exception('Failed to like comment');
    }
  }

  Future<void> unlikeComment(int commentId, int userId) async {
     var url = "$totalUrl/unlike";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.put(uri, headers: headers, body: jsonEncode({'commentId': commentId, 'userId': userId}),);
    
    if (isValidResponseCode(response)) {
      notifyListeners(); 
    } else {
      throw Exception('Failed to unlike comment');
    }
  }
}
