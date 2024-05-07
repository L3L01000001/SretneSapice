import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/providers/order_item_provider.dart';
import 'package:sretnesapice_mobile/providers/order_provider.dart';
import 'package:sretnesapice_mobile/providers/product_provider.dart';
import 'package:sretnesapice_mobile/providers/product_type_provider.dart';
import 'package:sretnesapice_mobile/providers/role_provider.dart';
import 'package:sretnesapice_mobile/providers/tag_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ForumPostProvider()),
        ChangeNotifierProvider(create: (_) => ProductTypeProvider()),
        ChangeNotifierProvider(create: (_) => DogWalkerProvider()),
        ChangeNotifierProvider(create: (_) => OrderItemProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => TagProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepPurple,
          fontFamily: 'Quicksand',
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic))),

          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          ),
        ),
        home: LoginPage(),
        onGenerateRoute: (settings) {
          if (settings.name == ProductListScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => ProductListScreen()));
          } else if (settings.name == ForumPostListScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => ForumPostListScreen()));
          }

          var uri = Uri.parse(settings.name!);
        },
      ),
    ));

class LoginPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo_png.png",
              height: 300,
              width: 480,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 121, 26, 222),
                        ),
                      ),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Korisničko ime je obavezno!";
                        } else if (value.length < 3) {
                          return "Korisničko ime ne može imati manje od 3 slova";
                        }
                        return null;
                      },
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      controller: _usernameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.account_circle,
                              color: Color(0xFF8031CC)),
                          hintText: "Korisničko ime",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 108, 21, 190))),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 121, 26, 222),
                        ),
                      ),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lozinka ne moze biti prazno polje";
                        } else if (value.length < 4) {
                          return "Lozinka ne može imati manje od 4 slova";
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(color: Color.fromARGB(255, 1, 1, 0)),
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.password, color: Color(0xFF8031CC)),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 108, 21, 190))),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(110, 4, 191, 1),
                          Color.fromRGBO(142, 67, 234, 0.6),
                        ],
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            Authorization.username = _usernameController.text;
                            Authorization.password = _passwordController.text;

                            Authorization.user =
                                await _userProvider.Authenticate();

                            if (Authorization.user?.userRoles.any(
                                        (role) => role.role?.name == "User") ==
                                    true ||
                                Authorization.user?.userRoles.any((role) =>
                                        role.role?.name == "DogWalker") ==
                                    true) {
                              Navigator.pushNamed(
                                  context, ForumPostListScreen.routeName);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                            "Nemate permisije za logiranje"),
                                        actions: [
                                          TextButton(
                                            child: Text("Ok"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ));
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Text("Netačni login podaci!"),
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
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Prijava",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF8031CC)),
                        ),
                        child: Text(
                          "Registracija",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ), 
                      Text("Zaboravljen password?"),
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    )));
  }
}
