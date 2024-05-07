import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/main.dart';
import 'package:sretnesapice_mobile/models/forum_post.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class ForumPostListScreen extends StatefulWidget {
  static const String routeName = "/forum";
  const ForumPostListScreen({super.key});

  @override
  State<ForumPostListScreen> createState() => _ForumPostListScreenState();
}

class _ForumPostListScreenState extends State<ForumPostListScreen> {
  ForumPostProvider? _forumPostProvider = null;
  List<ForumPost> data = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _forumPostProvider = context.read<ForumPostProvider>();

    loadData();
  }

  Future loadData() async {
    var fpData = await _forumPostProvider?.get(null);

    setState(() {
      data = fpData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(20),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer
                    Text(
                      "Odjava",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ), // Text
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
