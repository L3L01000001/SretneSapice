import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/screens/forum_post_details_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

class ForumPostCard extends StatelessWidget {
  final String? title;
  final String? content;
  final String? author;
  final DateTime? date;
  final int? postId;
  final int? numberOfComments;

  ForumPostCard(
      {required this.title,
      required this.content,
      required this.author,
      required this.date,
      required this.postId,
      required this.numberOfComments});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, "${ForumPostDetailsScreen.routeName}/${postId}");
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple,
                Colors.deepPurple
              ], 
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  content ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${numberOfComments.toString()} komentara',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                    ),
                    Column(children: [
                      Text(
                        author ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        formatDate(date),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
