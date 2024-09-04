import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/to_do_4924_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/screens/fromToDo4924.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

class FrmToDo4924NoviScreen extends StatefulWidget {
  static const routeName = '/add_to_do';
  const FrmToDo4924NoviScreen({super.key});

  @override
  State<FrmToDo4924NoviScreen> createState() => _FrmToDo4924NoviScreenState();
}

class _FrmToDo4924NoviScreenState extends State<FrmToDo4924NoviScreen> {
  ToDo4924Provider? _toDo4924Provider = null;
  UserProvider? _userProvider = null;

  final _formKey = GlobalKey<FormState>();

  final int selectedIndex = 1;
  List<User> userData = [];
  bool loading = false;
  DateTime date = DateTime.now();

  User? selectedUser;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _toDo4924Provider = context.read<ToDo4924Provider>();
    _userProvider = context.read<UserProvider>();

    loadUsers();
  }

  void loadUsers() async {
    var uData = await _userProvider?.get();

    setState(() {
      userData = uData!;
    });
  }

  bool _validateFields(String? title, String? postContent) {
    return title != null &&
        title.isNotEmpty &&
        postContent != null &&
        postContent.isNotEmpty;
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
        date = picked;
      });
    }
  }

  void insert() async {
    loading = true;
    try {
      String title = _titleController.text;
      String opis = _descriptionController.text;

      if (_validateFields(title, opis)) {
        Map obj = {
          "userId": selectedUser?.userId,
          "nazivAktivnosti": title,
          "opisAktivnosti": opis,
          "datumIzvrsenja": date,
          "statusAktivnosti": "U toku"
        };

        await _toDo4924Provider!.insert(obj);

        loading = false;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Objekat dodan!"),
          ),
        );

        Future.delayed(Duration(seconds: 3), () {
          Navigator.popAndPushNamed(context, FromToDo4924ListScreen.routeName);
        });
      }
    } catch (e) {
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: selectedIndex,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("Novi ToDo4924",
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 25),
                Text("Datum izvrsenja:"),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Text(
                      date != null ? formatDateOnly(date) : 'Izaberi datum',
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple)),
                ),
                _buildForm(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      insert();
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 108, 21, 190))),
                  child: loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Spremi",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ]),
            )),
      ),
    );
  }

  Widget _buildForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 238, 235, 241),
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 121, 26, 222),
            ),
          ),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Naziv aktivnosti',
            labelStyle: TextStyle(color: Color.fromARGB(255, 108, 21, 190)),
            hintStyle: Theme.of(context).textTheme.labelMedium,
          ),
          controller: _titleController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Morate unijeti naslov!";
            }
            return null;
          },
        ),
      ),
      SizedBox(height: 15),
      _buildUserDropdown(),
      const SizedBox(height: 16),
      Container(
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 238, 235, 241),
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 121, 26, 222),
            ),
          ),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Opis aktivnosti',
            labelStyle: TextStyle(color: Color.fromARGB(255, 108, 21, 190)),
            hintStyle: Theme.of(context).textTheme.bodySmall,
          ),
          maxLines: null,
          controller: _descriptionController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Morate unijeti sadržaj!";
            }
            return null;
          },
        ),
      ),
    ]);
  }

  Widget _buildUserDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      userData.isNotEmpty
          ? Container(
              padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 121, 26, 222),
                  ),
                ),
              ),
              child: DropdownButtonFormField<User>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Korisnik',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 121, 26, 222),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                value: selectedUser,
                icon: const Icon(Icons.arrow_drop_down),
                validator: (value) {
                  if (value == null) {
                    return 'Morate odabrati korisnika!';
                  }
                  return null;
                },
                onChanged: (User? value) {
                  setState(() {
                    selectedUser = value;
                  });
                },
                items: userData
                    .map((user) => DropdownMenuItem<User>(
                          value: user,
                          child: Text(
                            user.fullName ?? "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ))
                    .toList(),
              ),
            )
          : Container(),
    ]);
  }
}
