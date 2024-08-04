import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isLiked;
  final Function(bool) onLike;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.isLiked,
    required this.onLike
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(comment.user?.fullName ?? ""),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(comment.commentContent ?? ""),
            SizedBox(width: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.thumb_up_alt_sharp : Icons.thumb_up_off_alt,
                    size: 30,
                    color: Color.fromARGB(255, 108, 30, 203),
                  ),
                  onPressed: () {
                    onLike(!isLiked);
                  },
                ),
                SizedBox(width: 4),
                Text(
                  "${comment.likesCount ?? 0}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
