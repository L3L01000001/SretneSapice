import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/forum_post_provider.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class ForumPostListScreen extends StatefulWidget {
  const ForumPostListScreen({super.key});

  @override
  State<ForumPostListScreen> createState() => _ForumPostListScreenState();
}

class _ForumPostListScreenState extends State<ForumPostListScreen> {
  late ForumPostProvider _forumPostProvider;
  SearchResult<ForumPost>? result;
  TextEditingController _postContentController = TextEditingController();
  String? _selectedSortingOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _forumPostProvider = context.read<ForumPostProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _forumPostProvider.get();

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Forum postovi",
      initialIndex: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildSearch(),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildSortingDropdown()]),
          SizedBox(height: 16),
          _buildDataListView()
        ]),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.grey[100], 
        border: Border.all(
            color: Color(0xFF8031CC), width: 1.0), 
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Pretraži po sadržaju posta",
              suffixIcon: _postContentController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _postContentController.clear();
                        });
                      },
                    )
                  : null,
            ),
            controller: _postContentController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            var data = await _forumPostProvider
                .get(filter: {'postContent': _postContentController.text});
            setState(() {
              result = data;
            });
          },
          icon: Icon(Icons.search),
          label: Text("Pretraga"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(0xFF8031CC), width: 2.0),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
          border:
              Border.all(width: 2.0, color: Color.fromARGB(255, 61, 6, 137))),
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Sortiraj po:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Color.fromARGB(255, 61, 6, 137)),
              ),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(30),
        padding: EdgeInsets.all(8.0),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Najnovije') {
              var data = await _forumPostProvider.getForumPostsByNewest();
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Najstarije') {
              var data = await _forumPostProvider.getForumPostsByOldest();
              setState(() {
                result = data;
              });
            } else if (_selectedSortingOption == 'Najpopularnije') {
              var data = await _forumPostProvider.getForumPostsByMostPopular();
              setState(() {
                result = data;
              });
            } else {
              print('Invalid sorting option');
            }
          } catch (error) {
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Sortiraj po:',
          'Najnovije',
          'Najstarije',
          'Najpopularnije'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: result != null && result!.result.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: DataTable(
                  border: TableBorder.all(
                    style: BorderStyle.solid,
                    color: Color.fromARGB(255, 116, 57, 199),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  headingRowHeight: 50,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color.fromARGB(255, 67, 6, 137)),
                  dataRowMaxHeight: 100,
                  dataRowMinHeight: 40,
                  columns: [
                    const DataColumn(
                      label: Expanded(
                        child: Text('Autor posta',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Naslov',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Sadržaj',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Vrijeme kreiranja',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Tagovi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Slika',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                  ],
                  rows: result!.result
                      .map(
                        (ForumPost e) => DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            return Colors.white; //
                          }),
                          onLongPress: () => {},
                          cells: [
                            DataCell(Text(e.user?.fullName ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.title ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.postContent ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(formatDate(e.timestamp),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(
                              Text((e.forumPostTags?.map((t) => t?.tag?.tagName).join(', ') ?? 'Nema tagova'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                            DataCell(e.photo != ""
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: imageFromBase64String(e.photo!),
                                  )
                                : Text("Nema slike",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: Text(
                  'Nema posta koji u sadržaju ima traženu riječ/slovo!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}
