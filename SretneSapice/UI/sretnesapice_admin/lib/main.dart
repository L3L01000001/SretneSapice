import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_admin/providers/city_provider.dart';
import 'package:sretnesapice_admin/providers/dog_walker_provider.dart';
import 'package:sretnesapice_admin/providers/forum_post_provider.dart';
import 'package:sretnesapice_admin/providers/order_item_provider.dart';
import 'package:sretnesapice_admin/providers/order_provider.dart';
import 'package:sretnesapice_admin/providers/product_provider.dart';
import 'package:sretnesapice_admin/providers/report_provider.dart';
import 'package:sretnesapice_admin/providers/role_provider.dart';
import 'package:sretnesapice_admin/providers/tag_provider.dart';
import 'package:sretnesapice_admin/providers/user_provider.dart';
import 'package:sretnesapice_admin/providers/product_type_provider.dart';
import 'package:sretnesapice_admin/screens/dog_walkers_list_screen.dart';
import 'package:sretnesapice_admin/screens/product_list_screen.dart';
import 'package:sretnesapice_admin/utils/util.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductTypeProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ForumPostProvider()),
      ChangeNotifierProvider(create: (_) => TagProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => OrderItemProvider()),
      ChangeNotifierProvider(create: (_) => DogWalkerProvider()),
      ChangeNotifierProvider(create: (_) => RoleProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
      ChangeNotifierProvider(create: (_) => ReportProvider())
    ],
    child: const MyMaterialApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: MyMaterialApp());
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sretne šapice",
      theme: myTheme,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late UserProvider _userProvider;
  int? loggedInUserID;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    var username = _usernameController.text;
    var password = _passwordController.text;

    Authorization.username = username;
    Authorization.password = password;

    try {
      Authorization.user = await _userProvider.Authenticate();

      if (Authorization.user?.status == true) {
        if (Authorization.user?.userRoles
                .any((role) => role.role?.name == "Administrator") ==
            true) {
          setState(() {
            loggedInUserID = Authorization.user?.userId;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProductListScreen(),
            ),
          );
        } else if (Authorization.user?.userRoles
                .any((role) => role.role?.name == "DogWalkerVerifier") ==
            true) {
          setState(() {
            loggedInUserID = Authorization.user?.userId;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DogWalkersListScreen(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(
                  "Vaš korisnički račun nema permisije za pristup admin panelu!"),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Vaš korisnički račun je trenutno neaktivan! Kontaktirajte sretnesapice@outlook.com za pomoć."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
          ),
        );
      }
    } on Exception {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Text("Pogrešno korisničko ime ili lozinka!"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = context.read<UserProvider>();

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo_png.png",
                    height: 300,
                    width: 480,
                  ),
                  Text(
                    "Dobrodošli u admin panel!",
                    style: TextStyle(fontSize: 22, color: Color(0xFF8031CC)),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x298031CC),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Korisničko ime",
                        labelStyle: TextStyle(color: Color(0xFF8031CC)),
                        prefixIcon: Icon(Icons.account_circle,
                            color: Color(0xFF8031CC)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      controller: _usernameController,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x298031CC),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Color(0xFF8031CC)),
                        prefixIcon:
                            Icon(Icons.password, color: Color(0xFF8031CC)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF8031CC)),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final ThemeData myTheme = ThemeData(
  primarySwatch: Colors.purple,
  primaryColor: Color(0xFF8031CC),
  fontFamily: 'Quicksand',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
);
