import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/requests/dog_walker_request.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/widgets/text_input_widget.dart';

class DogWalkerApplicationScreen extends StatefulWidget {
  static const String routeName = '/apply';
  const DogWalkerApplicationScreen({super.key});

  @override
  State<DogWalkerApplicationScreen> createState() =>
      _DogWalkerApplicationScreenState();
}

class _DogWalkerApplicationScreenState
    extends State<DogWalkerApplicationScreen> {
  CityProvider? _cityProvider = null;
  DogWalkerProvider? _dogWalkerProvider = null;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  City? selectedCity;
  List<City> cities = [];

  DogWalkerRequest dogWalkerRequest = new DogWalkerRequest();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _cityProvider = context.read<CityProvider>();

    loadCities();
  }

  void loadCities() async {
    var citiesData = await _cityProvider?.get();

    setState(() {
      cities = citiesData!;
      print(cities);
    });
  }

  void apply() async {
    try {
      dogWalkerRequest.name = _nameController.text;
      dogWalkerRequest.surname = _surnameController.text;
      dogWalkerRequest.age = int.parse(_ageController.text);
      dogWalkerRequest.phone = _phoneController.text;
      dogWalkerRequest.cityID = selectedCity!.cityID;
      dogWalkerRequest.profilePhoto =
          base64Encode(_imageFile!.readAsBytesSync());

      var applicant = await _dogWalkerProvider?.insert(dogWalkerRequest);

      if (applicant != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Uspješno ste aplicirali za poziciju šetača!"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.popAndPushNamed(
                            context, DogWalkerListScreen.routeName),
                        child: Text("Ok"))
                  ],
                ));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Nemoguće poslati aplikaciju. Provjerite formu!"),
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
        child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("Prijava za šetača",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Color(0xff1590a1))),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setInput(context, "Ime", _nameController, 2, 1),
                    setInput(context, "Prezime", _surnameController, 2, 1),
                    setInput(context, "Godine", _ageController, 2, 1),
                    setInput(context, "Broj telefona", _phoneController, 9, 1),
                    _buildLocationDropdown(),
                    setInput(
                        context, "Iskustvo", _experienceController, 10, 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Fotografija (obavezno)",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontSize: 18, color: Color(0xff1590a1))),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: getImageFromGallery,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(0xff1590a1),
                                  child: _imageFile == null
                                      ? Icon(Icons.add,
                                          size: 50, color: Colors.white)
                                      : null,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff1590a1))),
                child: Text("Apliciraj",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ]),
          )),
    ));
  }

  Widget _buildLocationDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      cities.isNotEmpty
          ? Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff1590a1),
                  ),
                ),
              ),
              child: DropdownButton<City>(
                isExpanded: true,
                underline: Container(),
                value: selectedCity,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text(
                  'Grad',
                  style: TextStyle(
                      color: Color(0xff1590a1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                elevation: 16,
                borderRadius: BorderRadius.circular(5),
                onChanged: (City? value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                items: cities
                        .map((city) => DropdownMenuItem<City>(
                              alignment: AlignmentDirectional.center,
                              value: city,
                              child: Text(city.name ?? "",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ))
                        .toList() ??
                    [],
              ),
            )
          : Container(),
    ]);
  }

  Container setInput(BuildContext context, String label,
      TextEditingController controller, int minLength, int maxLines) {
    var phoneNumber = false;

    if (label == "Broj telefona") phoneNumber = true;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            labelText: label,
            controller: controller,
            minLength: minLength,
            isEmail: false,
            isPhoneNumber: phoneNumber,
            color: Color(0xff1590a1),
            maxLines: maxLines,
          )
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
