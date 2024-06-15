import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/dog_walker.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/providers/dog_walker_provider.dart';
import 'package:sretnesapice_admin/screens/dog_walker_details_screen.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class DogWalkersListScreen extends StatefulWidget {
  const DogWalkersListScreen({super.key});

  @override
  State<DogWalkersListScreen> createState() => _DogWalkersListScreenState();
}

class _DogWalkersListScreenState extends State<DogWalkersListScreen> {
  late DogWalkerProvider _dogWalkerProvider;
  SearchResult<DogWalker>? result;
  TextEditingController _nameSurnameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _dogWalkerProvider.get();

    setState(() {
      result = data;
    });
  }

  void _approveDogWalker(int dogWalkerId) async {
    try {
      await context.read<DogWalkerProvider>().approve(dogWalkerId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Odobrena aplikacija!'),
      ));
      _loadData(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Greška!'),
      ));
    }
  }

  void _rejectDogWalker(int dogWalkerId) async {
    try {
      await _dogWalkerProvider.reject(dogWalkerId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Aplikacija odbijena!'),
      ));
      _loadData(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Greška!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Šetači",
      initialIndex: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearch(),
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
        border: Border.all(color: Color(0xff1590a1), width: 1.0),
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Ime ili prezime šetača",
              suffixIcon: _nameSurnameController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _nameSurnameController.clear();
                        });
                      },
                    )
                  : null,
            ),
            controller: _nameSurnameController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            var data = await _dogWalkerProvider
                .get(filter: {'fullName': _nameSurnameController.text});
            setState(() {
              result = data;
            });
          },
          icon: Icon(Icons.search, color: Color(0xff1590a1)),
          label: Text("Pretraga", style: TextStyle(color: Color(0xff1590a1))),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(0xff1590a1), width: 2.0),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        )
      ]),
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
                    color: Color(0xff1590a1),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  headingRowHeight: 50,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xff09424a)),
                  dataRowMaxHeight: 150,
                  dataRowMinHeight: 60,
                  columns: [
                    const DataColumn(
                      label: Expanded(
                        child: Text('ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Ime',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Prezime',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Godine',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Telefon',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Iskustvo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Status',
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
                    const DataColumn(
                      label: Expanded(
                        child: Text('',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ],
                  rows: result!.result
                      .map(
                        (DogWalker e) => DataRow(
                          onLongPress: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DogWalkerDetailsScreen(
                                  dogWalker: e,
                                ),
                              ),
                            )
                          },
                          cells: [
                            DataCell(Text(e.dogWalkerId?.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.name ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.surname ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.age.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.phone ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.experience ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.status ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(e.dogWalkerPhoto != ""
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: imageFromBase64String(
                                        e.dogWalkerPhoto!),
                                  )
                                : Text("Nema slike")),
                            DataCell(Row(
                              children: _buildActionButtons(e),
                            )),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: Text(
                  'Nema šetača koji odgovaraju pretrazi!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildActionButtons(DogWalker dogWalker) {
    List<Widget> buttons = [];
    if (dogWalker.status == "Pending") {
      buttons.add(
        ElevatedButton(
          onPressed: () => _approveDogWalker(dogWalker.dogWalkerId!),
          child: Text('Accept'),
        ),
      );
      buttons.add(SizedBox(width: 8));
      buttons.add(
        ElevatedButton(
          onPressed: () => _rejectDogWalker(dogWalker.dogWalkerId!),
          child: Text('Odbij aplikacijsku formu'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    } else if (dogWalker.status == "Approved") {
      buttons.add(
        ElevatedButton(
          onPressed: () => _rejectDogWalker(dogWalker.dogWalkerId!),
          child: Text('Ukini ulogu',
              style: TextStyle(
                color: Colors.white,
              )),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    } else if (dogWalker.status == "Rejected") {
      buttons.add(
        ElevatedButton(
          onPressed: () => _approveDogWalker(dogWalker.dogWalkerId!),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Prihvati aplikacijsku formu',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      );
    }
    return buttons;
  }
}
