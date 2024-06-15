import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/requests/user_update_request.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/screens/settings_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/widgets/text_input_widget.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserProvider? _userProvider = null;
  User? user = null;
  UserUpdateRequest userUpdateRequest = new UserUpdateRequest();

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    loadData();
  }

  Future loadData() async {
    if (Authorization.user!.userId != null) {
      var tmpData = await _userProvider?.getById(Authorization.user!.userId!);

      setState(() {
        user = tmpData;
        _firstNameController.text = tmpData?.name ?? "";
        _lastnameController.text = tmpData?.surname ?? "";
        _emailController.text = tmpData?.email ?? "";
        _phoneController.text = tmpData?.phone ?? "";
        _usernameController.text = tmpData?.username ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return LoadingScreen();
    return Form(
      key: _formKey,
      child: MasterScreenWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Uredi Profil"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          _imageFile == null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: user!.profilePhoto != null
                                      ? MemoryImage(base64Decode(user!.profilePhoto!))
                                      : null,
                                  child: user!.profilePhoto == null
                                      ? Icon(Icons.person, size: 50)
                                      : null,
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(_imageFile!),
                                ),
                          TextButton(
                            onPressed: getImageFromGallery,
                            child: Text('Izaberi Sliku'),
                          ),
                        ],
                      ),
                    ),
                    setInput(context, "Ime", _firstNameController, 2),
                    setInput(context, "Prezime", _lastnameController, 2),
                    setInput(context, "Email", _emailController, 7),
                    setInput(context, "Broj telefona", _phoneController, 9),
                    setInput(context, "Korisničko ime", _usernameController, 6),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      userUpdateRequest.name = _firstNameController.text;
                      userUpdateRequest.surname = _lastnameController.text;
                      userUpdateRequest.email = _emailController.text;
                      userUpdateRequest.phone = _phoneController.text;
                      userUpdateRequest.username = _usernameController.text;
                       if (_base64Image != null) {
                        userUpdateRequest.profilePhoto = _base64Image;
                      }

                      await _userProvider?.update(
                          user!.userId, userUpdateRequest);
                      Navigator.pushNamed(context, SettingsScreen.routeName);
                    } catch (e) {
                      print("greska");
                    }
                  }
                },
                child: Text('Sačuvaj'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container setInput(BuildContext context, String label,
      TextEditingController controller, int minLength) {
    var email = false;
    var phoneNumber = false;

    if (label == "Email") email = true;
    if (label == "Broj telefona") phoneNumber = true;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(label, style: Theme.of(context).textTheme.bodyText2),
          ),
          TextInputWidget(
              labelText: label,
              controller: controller,
              minLength: minLength,
              isEmail: email,
              isPhoneNumber: phoneNumber,
              color: Color.fromARGB(255, 121, 26, 222),),
        ],
      ),
    );
  }

  File? _imageFile;
  String? _base64Image;

  Future getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image != null ? File(image.path) : null;
    });
  }
}
