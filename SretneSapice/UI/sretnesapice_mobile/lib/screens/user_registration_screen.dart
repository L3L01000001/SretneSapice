import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/main.dart';
import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/models/search_result.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/requests/registration_request.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/widgets/text_input_widget.dart';

class UserRegistrationScreen extends StatefulWidget {
  static const String routeName = "/registration";
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  UserProvider? _userProvider = null;
  CityProvider? _cityProvider = null;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  City? selectedCity;
  List<City> cities = [];

  RegistrationRequest registrationRequest = new RegistrationRequest();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();

    loadCities();
  }

  void loadCities() async {
    var citiesData = await _cityProvider?.get();

    setState(() {
      cities = citiesData!;
    });
  }

  void register() async {
    try {
      registrationRequest.name = _nameController.text;
      registrationRequest.surname = _surnameController.text;
      registrationRequest.username = _usernameController.text;
      registrationRequest.email = _emailController.text;
      registrationRequest.phone = _phoneController.text;
      registrationRequest.password = _passwordController.text;
      registrationRequest.confirmPassword = _confirmPasswordController.text;
      registrationRequest.cityID = selectedCity!.cityID;

      var registeredUser = await _userProvider?.register(registrationRequest);

      if (registeredUser != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Uspješna registracija!"),
                  content: Text(
                      style: Theme.of(context).textTheme.bodyText1,
                      "Registriran korisnik ${registeredUser.name}"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.popAndPushNamed(
                            context, ForumPostListScreen.routeName),
                        child: Text("Ok"))
                  ],
                ));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Nemoguće obaviti registraciju!"),
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
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        body: Stack(children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/background.jpg',
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(.3),
        ),
      ),
      SafeArea(
          child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/circle_logo.png",
                height: 170,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Registracija",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextInputWidget(
                        labelText: "Ime",
                        controller: _nameController,
                        minLength: 2,
                        isEmail: false,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    TextInputWidget(
                        labelText: "Prezime",
                        controller: _surnameController,
                        minLength: 2,
                        isEmail: false,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    TextInputWidget(
                        labelText: "Username",
                        controller: _usernameController,
                        minLength: 6,
                        isEmail: false,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    TextInputWidget(
                        labelText: "Email",
                        controller: _emailController,
                        minLength: 7,
                        isEmail: true,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    TextInputWidget(
                        labelText: "Telefon",
                        controller: _phoneController,
                        minLength: 9,
                        isEmail: false,
                        isPhoneNumber: true,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    _buildLocationDropdown(),
                    TextInputWidget(
                        labelText: "Lozinka",
                        controller: _passwordController,
                        minLength: 6,
                        isEmail: false,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    TextInputWidget(
                        labelText: "Potvrdi lozinku",
                        controller: _confirmPasswordController,
                        minLength: 6,
                        isEmail: false,
                        isPhoneNumber: false,
                        color: Color.fromARGB(255, 121, 26, 222)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF8031CC)),
                      ),
                      child: Text(
                        "Kreiraj račun",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Već imate račun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: Text(
                            "Prijavite se",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      )),
    ]));
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
                    color: Color.fromARGB(255, 121, 26, 222),
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
                      color: Color.fromARGB(255, 108, 21, 190),
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
}
