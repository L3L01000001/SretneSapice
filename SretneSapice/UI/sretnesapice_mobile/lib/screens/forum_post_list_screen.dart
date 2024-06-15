import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/main.dart';
import 'package:sretnesapice_mobile/models/forum_post.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/screens/add_forum_post_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/forum_post_card.dart';
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
  String? _selectedSortingOption;

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
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostSearch(),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: _buildSortingDropdown(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: _buildForumPostCardList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(
                    context, AddForumPostScreen.routeName);
              },
              child: Icon(Icons.add, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) async {
                var tmpData =
                    await _forumPostProvider?.get({'postContent': value});
                setState(() {
                  data = tmpData!;
                });
              },
              decoration: InputDecoration(
                  hintText: "Pretraga",
                  hintStyle: TextStyle(color: Colors.purple[900]),
                  labelStyle: TextStyle(color: Color(0xFF4A148C)),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      'assets/icons/search-icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF4A148C)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF4A148C)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      height: 50,
      child: DropdownButton<String>(
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Sortiraj po:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color(0xFF4A148C)),
              ),
            ],
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A148C)),
        borderRadius: BorderRadius.circular(10),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Najnovije') {
              var tmpdata = await _forumPostProvider!.getForumPostsByNewest();
              setState(() {
                data = tmpdata;
              });
            } else if (_selectedSortingOption == 'Najstarije') {
              var tmpdata = await _forumPostProvider!.getForumPostsByOldest();
              setState(() {
                data = tmpdata;
              });
            } else if (_selectedSortingOption == 'Najpopularnije') {
              var tmpdata =
                  await _forumPostProvider!.getForumPostsByMostPopular();
              setState(() {
                data = tmpdata;
              });
            } else {
              print('Invalid sorting option');
            }
          } catch (error) {
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Preporučeno',
          'Najnovije',
          'Najstarije',
          'Najpopularnije'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.center,
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildForumPostCardList() {
    if (data.length == 0) {
      return []; 
    }
    return data.map((post) {
      return ForumPostCard(
        title: post.title,
        content: post.postContent,
        author: post.user?.fullName,
        date: post.timestamp,
        numberOfComments: post.comments?.length ?? 0,
        postId: post.postId, 
      );
    }).toList();
  }
}