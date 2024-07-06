import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/comment.dart';
import 'package:sretnesapice_mobile/models/forum_post.dart';
import 'package:sretnesapice_mobile/providers/comment_like_provider.dart';
import 'package:sretnesapice_mobile/providers/comment_provider.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class ForumPostDetailsScreen extends StatefulWidget {
  static const String routeName = '/forum_post';
  String id;
  ForumPostDetailsScreen(this.id, {super.key});

  @override
  State<ForumPostDetailsScreen> createState() => _ForumPostDetailsScreenState();
}

class _ForumPostDetailsScreenState extends State<ForumPostDetailsScreen> {
  ForumPostProvider? _forumPostProvider;
  CommentProvider? _commentProvider;
  CommentLikeProvider? _commentLikeProvider;
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ForumPost? forumPost;

  final int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _forumPostProvider = context.read<ForumPostProvider>();
    _commentProvider = context.read<CommentProvider>();
    _commentLikeProvider = context.read<CommentLikeProvider>();

    loadData();
  }

  Future loadData() async {
    var forumPost = await _forumPostProvider!.getById(int.parse(widget.id));

    setState(() {
      this.forumPost = forumPost;
    });
  }

  bool _validateFields(String? commentContent) {
    return commentContent != null && commentContent.isNotEmpty;
  }

  void _submitComment() async {
    String commentContent = _commentController.text;
    int userId = Authorization.user!.userId;
    int postId = int.parse(widget.id);

    if (_validateFields(commentContent)) {
      Map comment = {
        "postId": postId,
        "userId": userId,
        "commentContent": commentContent
      };

      Comment? newComment = await _commentProvider!.insert(comment);
      if (newComment != null) {
        setState(() {
          forumPost!.comments!.add(newComment);
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Nešto je pošlo po zlu! Nemoguće objaviti ovaj post."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (forumPost == null) {
      loadData();
      return LoadingScreen();
    } else {
      return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForumPostDetailsCard(),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 5), 
                      child: Text(
                        "Komentari:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff52297a),
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: forumPost!.comments?.length,
                      itemBuilder: (context, index) {
                        return CommentWidget(
                            comment: forumPost!.comments![index]);
                      },
                    ),
                    buildInsertComment(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildForumPostDetailsCard() {
    return Card(
      elevation: 4,
      color: Color(0xff52297a),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Autor: ${forumPost!.user!.fullName}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            // Title
            Text(
              forumPost!.title!,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            // Content
            Text(forumPost!.postContent!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            // Photo
            InkWell(
              onTap: () {},
              child: forumPost!.photo != ""
                  ? Container(
                      width: double.infinity,
                      child: imageFromBase64String(forumPost!.photo!),
                    )
                  : Container(),
            ),
            SizedBox(height: 10),
            // Tags
            Text(
              'Tags: ${forumPost!.forumPostTags?.map((t) => t.tag?.tagName).join(", ")}',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildInsertComment() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Dodaj komentar',
                    border: InputBorder.none,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitComment();
                  }
                },
                child: Icon(Icons.arrow_forward, color: Colors.white),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff52297a)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment? comment;

  const CommentWidget({required this.comment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comment == null) {
      return Container();
    }

    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(comment!.user?.fullName ?? ""),
        subtitle: Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(comment!.commentContent ?? ""),
            SizedBox(width: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_off_alt),
                SizedBox(width: 4),
                Text(
                  "${comment!.likesCount ?? 0}",
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
