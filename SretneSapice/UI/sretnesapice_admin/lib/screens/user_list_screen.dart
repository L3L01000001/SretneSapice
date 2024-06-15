import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/providers/user_provider.dart';
import 'package:sretnesapice_admin/screens/user_details_screen.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';
import 'package:sretnesapice_admin/widgets/user_list_filter.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserProvider _userProvider;
  SearchResult<User>? result;
  TextEditingController _nameController = TextEditingController();
  List<String> _selectedRoles = [];
  bool? _isActive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.read<UserProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _userProvider.get(filter: {
      'isRoleIncluded': true,
      'roles': _selectedRoles.isNotEmpty ? _selectedRoles.join(',') : null,
      'isActive': _isActive != null ? _isActive.toString() : null,
    });

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Korisnici",
      initialIndex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildSearch(),
          UserListFilter(
            onFilterChanged: (selectedRoles, isActive) {
              setState(() {
                _selectedRoles = selectedRoles;
                _isActive = isActive;
              });
              _loadData();
            },
          ),
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
        color: Colors.grey[100], // Set border radius here
        border: Border.all(
            color: Color.fromARGB(255, 61, 6, 137),
            width: 1.0), // Add border properties here
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Ime korisnika",
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _nameController.clear();
                        });
                      },
                    )
                  : null,
            ),
            controller: _nameController,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            var data =
                await _userProvider.get(filter: {'name': _nameController.text});
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
                    color: Color.fromARGB(255, 116, 57, 199),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  headingRowHeight: 50,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color.fromARGB(255, 61, 6, 137)),
                  dataRowMaxHeight: 100,
                  dataRowMinHeight: 40,
                  columns: [
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
                        child: Text('Email',
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
                        child: Text('Korisničko ime',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Grad',
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
                        child: Text('Uloge',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                    const DataColumn(
                      label: Expanded(
                        child: Text('Status računa',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 242, 237, 247),
                                fontSize: 18)),
                      ),
                    ),
                  ],
                  rows: result!.result
                      .map(
                        (User e) => DataRow(
                          onLongPress: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserDetailsScreen(
                                  user: e,
                                ),
                              ),
                            )
                          },
                          cells: [
                            DataCell(Text(e.name ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.surname ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.email ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.phone ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.username ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(e.city?.name ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(
                              Text(
                                e.status != null
                                    ? (e.status! ? 'Aktivan' : 'Neaktivan')
                                    : '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.userRoles
                                    .map((role) => role.role?.name)
                                    .join(', '),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            DataCell(GestureDetector(
                              onTap: () {
                                if (e.status != null && e.status == true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                            "Jeste li sigurni da želite onemogućiti pristup ovom korisniku?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await _userProvider
                                                  .delete(e.userId!);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            content: Text(
                                                                "Korisniku uspješno onemogućen pristup!"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const UserListScreen(),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    Text("OK"),
                                                              )
                                                            ],
                                                          ));
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            child: Text("Onemogući",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Odustani"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (e.status != null &&
                                    e.status == false) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                            "Jeste li sigurni da želite omogućiti pristup ovom korisniku?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Map<String, dynamic>
                                                  statusUpdateRequest = {
                                                'status': true,
                                              };
                                              await _userProvider.update(
                                                  e.userId!,
                                                  statusUpdateRequest);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            content: Text(
                                                                "Korisniku uspješno omogućen pristup!"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const UserListScreen(),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    Text("OK"),
                                                              )
                                                            ],
                                                          ));
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            child: Text("Omogući",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Odustani"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: e.status != null && e.status!
                                  ? Icon(Icons.toggle_on, color: Colors.green)
                                  : Icon(Icons.toggle_off,
                                      color: Color.fromARGB(255, 233, 21, 14)),
                            ))
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            : Center(
                child: Text(
                  'Nema korisnika koji odgovaraju ovom zahtjevu!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      ),
    );
  }
}
