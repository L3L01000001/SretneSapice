import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/availability_provider.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/comment_like_provider.dart';
import 'package:sretnesapice_mobile/providers/comment_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_location_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/favorite_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/forum_post_provider.dart';
import 'package:sretnesapice_mobile/providers/order_item_provider.dart';
import 'package:sretnesapice_mobile/providers/order_provider.dart';
import 'package:sretnesapice_mobile/providers/payment_provider.dart';
import 'package:sretnesapice_mobile/providers/product_provider.dart';
import 'package:sretnesapice_mobile/providers/product_type_provider.dart';
import 'package:sretnesapice_mobile/providers/role_provider.dart';
import 'package:sretnesapice_mobile/providers/service_request_provider.dart';
import 'package:sretnesapice_mobile/providers/tag_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/providers/user_shipping_information_provider.dart';
import 'package:sretnesapice_mobile/providers/walker_review_provider.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/screens/add_forum_post_screen.dart';
import 'package:sretnesapice_mobile/screens/cart_screen.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_application_screen.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_details_screen.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/screens/edit_profile_screen.dart';
import 'package:sretnesapice_mobile/screens/forum_post_details_screen.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/product_details_screen.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';
import 'package:sretnesapice_mobile/screens/service_request_list_screen.dart';
import 'package:sretnesapice_mobile/screens/settings_screen.dart';
import 'package:sretnesapice_mobile/screens/user_registration_screen.dart';
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
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => CommentLikeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteWalkerProvider()),
        ChangeNotifierProvider(create: (_) => WalkerReviewProvider()),
        ChangeNotifierProvider(
            create: (_) => UserShippingInformationProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
        ChangeNotifierProvider(create: (_) => AvailabilityProvider()),
        ChangeNotifierProvider(create: (_) => DogWalkerLocationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepPurple,
          fontFamily: 'Quicksand',
          textTheme: TextTheme(
              bodySmall: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 108, 21, 190)),
              labelMedium: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 108, 21, 190)),
              titleLarge: TextStyle(
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 108, 21, 190))),
        ),
        home: LoginPage(),
        onGenerateRoute: (settings) {
          if (settings.name == ForumPostListScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => ForumPostListScreen()));
          } else if (settings.name == DogWalkerListScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => DogWalkerListScreen()));
          } else if (settings.name == LoginPage.routeName) {
            return MaterialPageRoute(builder: ((context) => LoginPage()));
          } else if (settings.name == ProductListScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => ProductListScreen()));
          } else if (settings.name == SettingsScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => SettingsScreen()));
          } else if (settings.name == AddForumPostScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => AddForumPostScreen()));
          } else if (settings.name == UserRegistrationScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => UserRegistrationScreen()));
          } else if (settings.name == EditProfileScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => EditProfileScreen()));
          } else if (settings.name == DogWalkerApplicationScreen.routeName) {
            return MaterialPageRoute(
                builder: ((context) => DogWalkerApplicationScreen()));
          } else if (settings.name == CartScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => CartScreen()));
          } else if (settings.name == ServiceRequestListScreen.routeName) {
            return MaterialPageRoute(
              builder: (context) => ServiceRequestListScreen(
                id: 0,
              ),
            );
          }

          var uri = Uri.parse(settings.name!);
          if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" ==
                  ForumPostDetailsScreen.routeName) {
            var id = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => ForumPostDetailsScreen(id));
          } else if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" == ProductDetailsScreen.routeName) {
            var id = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(id));
          } else if (uri.pathSegments.length == 2 &&
              "/${uri.pathSegments.first}" ==
                  DogWalkerDetailsScreen.routeName) {
            var id = uri.pathSegments[1];
            return MaterialPageRoute(
                builder: (context) => DogWalkerDetailsScreen(id));
          }
        },
      ),
    ));

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserProvider _userProvider;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              opacity: AlwaysStoppedAnimation(.3),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/circle_logo.png",
                      height: 300,
                      width: 480,
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                style: Theme.of(context).textTheme.bodySmall,
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.account_circle,
                                      color: Color(0xFF8031CC)),
                                  hintText: "Korisničko ime",
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
                            ),
                            SizedBox(height: 10),
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
                                style: Theme.of(context).textTheme.bodySmall,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.password,
                                      color: Color(0xFF8031CC)),
                                  hintText: "Password",
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
                            ),
                            SizedBox(height: 40),
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
                                onTap: _isLoading ? null : _login,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isLoading)
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    else
                                      Text(
                                        "Prijava",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    if (!_isLoading) SizedBox(width: 8),
                                    if (!_isLoading)
                                      Icon(
                                        Icons.login,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      Navigator.pushNamed(context,
                                          UserRegistrationScreen.routeName);
                                    } catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: Text(
                                              "Nemoguće otvoriti formu za registraciju trenutno!"),
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
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF8031CC)),
                                  ),
                                  child: Text(
                                    "Registracija",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 18),
                                Text("Zaboravljen password?"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Authorization.username = _usernameController.text;
        Authorization.password = _passwordController.text;

        Authorization.user = await _userProvider.Authenticate();

        if (Authorization.user?.userRoles
                    .any((role) => role.role?.name == "User") ==
                true ||
            Authorization.user?.userRoles
                    .any((role) => role.role?.name == "DogWalker") ==
                true) {
          Navigator.pushNamed(context, ForumPostListScreen.routeName);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Error"),
                    content: Text("Nemate permisije za logiranje"),
                    actions: [
                      TextButton(
                        child: Text("Ok"),
                        onPressed: () => Navigator.pop(context),
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
