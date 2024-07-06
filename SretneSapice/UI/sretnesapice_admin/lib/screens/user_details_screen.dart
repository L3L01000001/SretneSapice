import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/models/city.dart';
import 'package:sretnesapice_admin/models/search_result.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/providers/city_provider.dart';
import 'package:sretnesapice_admin/providers/user_provider.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  User? user;
  UserDetailsScreen({super.key, this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UserProvider _userProvider;
  late CityProvider _cityProvider;

  SearchResult<City>? citiesResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'name': widget.user?.name,
      'surname': widget.user?.surname,
      'email': widget.user?.email,
      'phone': widget.user?.phone,
      'username': widget.user?.username,
      'profilePhoto': widget.user?.profilePhoto,
      'status': widget.user?.status?.toString(),
      'cityID': widget.user?.cityID
    };

    _cityProvider = context.read<CityProvider>();
    _userProvider = context.read<UserProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    citiesResult = await _cityProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: 1,
        title: widget.user?.name ?? "Novi korisnik?",
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                isLoading ? Container() : _buildForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.all(10), child: Container())
                  ],
                )
              ],
            ),
          ),
        ),
        );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Container(
        color: Color.fromARGB(255, 223, 212, 244),
        padding: EdgeInsets.all(20),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Ime"),
                      name: "name",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Prezime"),
                      name: "surname",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Korisničko ime"),
                      name: "username",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Telefon"),
                      name: "phone",
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: FormBuilderDropdown<String>(
                    name: 'cityID',
                    initialValue: widget.user != null
                        ? widget.user?.cityID?.toString()
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Grad',
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['cityID']?.reset();
                          },
                        ),
                        hintText: 'Grad'),
                    items: citiesResult?.result
                            .map((item) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  value: item.cityID.toString(),
                                  child: Text(item.name ?? ""),
                                ))
                            .toSet()
                            .toList() ??
                        [],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Email"),
                      name: "email",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: null,
                      decoration: InputDecoration(labelText: "Status"),
                      name: "status",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          color: Colors.grey[200],
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_base64Image != null)
                                Image.memory(
                                  base64Decode(_base64Image!),
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              else if (widget.user == null)
                                Icon(Icons.photo, size: 100, color: Colors.grey)
                              else if (widget.user?.profilePhoto != "")
                                imageFromBase64String(
                                    widget.user!.profilePhoto!)
                              else
                                Icon(Icons.photo, size: 100, color: Colors.grey)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: FormBuilderField(
                      name: 'imageId',
                      builder: ((field) {
                        return Container(
                          child: ElevatedButton.icon(
                            onPressed: getImage,
                            icon: Icon(Icons.file_upload),
                            label: Text("Odaberi sliku"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Color(0xFF8031CC), width: 2.0),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }
}
