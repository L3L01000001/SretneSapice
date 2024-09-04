import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/to_do_4924.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/to_do_4924_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/screens/frmToDo4924Novi.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class FromToDo4924ListScreen extends StatefulWidget {
  static const String routeName = "/4924";
  const FromToDo4924ListScreen({super.key});

  @override
  State<FromToDo4924ListScreen> createState() => _FromToDo4924ListScreenState();
}

class _FromToDo4924ListScreenState extends State<FromToDo4924ListScreen> {
  final int selectedIndex = 1;
  ToDo4924Provider? _toDo4924Provider = null;
  UserProvider? _userProvider = null;

  List<ToDo4924> data = [];
  List<User> userData = [];
  bool loading = false;
  DateTime? filterDate;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _toDo4924Provider = context.read<ToDo4924Provider>();
    _userProvider = context.read<UserProvider>();

    loadData();
  }

  Future loadData() async {
    loading = true;
    try {
      var dData = await _toDo4924Provider?.get(null);
      var uData = await _userProvider?.get(null);

      setState(() {
        data = dData!;
        userData = uData!;
      });
      loading = false;
    } on Exception catch (e) {
      errorDialog(context, e);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        filterDate = picked;
      });
    }

    var filtered = await _toDo4924Provider?.get({'datumVazenja': filterDate});

    setState(() {
      data = filtered!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildToDoSearch(),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 53, 3, 61),
                        Color.fromARGB(255, 10, 77, 119)
                      ])),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                        filterDate != null
                            ? formatDateOnly(filterDate)
                            : 'Izaberi datum za filtriranje',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FrmToDo4924NoviScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF8031CC)),
                        ),
                        child: Text(
                          "Dodaj",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 700,
                  padding: EdgeInsets.all(26.0),
                  child: data.isEmpty
                      ? Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Center(child: CircularProgressIndicator()))
                      : GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 30),
                          scrollDirection: Axis.vertical,
                          children: _buildCardList(),
                        ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildToDoSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) async {
                var tmpData =
                    await _toDo4924Provider?.get({'statusAktivnosti': value});
                setState(() {
                  data = tmpData!;
                });
              },
              decoration: InputDecoration(
                  hintText: "Pretraga",
                  hintStyle: TextStyle(color: Colors.blue[900]),
                  labelStyle: TextStyle(color: Colors.blue[900]),
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
                    borderSide: BorderSide(color: Color(0xff315ccc)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff315ccc)))),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCardList() {
    List<Widget> list = data
        .map((x) => Container(
              width: 130,
              height: 220,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xff315ccc),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Text(x.user?.fullName ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(x.nazivAktivnosti ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(x.opisAktivnosti ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(x.statusAktivnosti ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(x.datumIzvrsenja.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
