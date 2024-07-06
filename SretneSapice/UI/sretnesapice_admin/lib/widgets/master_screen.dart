import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sretnesapice_admin/main.dart';
import 'package:sretnesapice_admin/models/user.dart';
import 'package:sretnesapice_admin/screens/dog_walkers_list_screen.dart';
import 'package:sretnesapice_admin/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_admin/screens/order_list_screen.dart';
import 'package:sretnesapice_admin/screens/product_list_screen.dart';
import 'package:sretnesapice_admin/screens/product_details_screen.dart';
import 'package:sretnesapice_admin/screens/reports_screen.dart';
import 'package:sretnesapice_admin/screens/user_list_screen.dart';
import 'package:sretnesapice_admin/utils/util.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  int initialIndex; 
  MasterScreenWidget(
      {this.child, this.title, required this.initialIndex, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _selectedIndex = 0;

  User? user = Authorization.user;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialIndex; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.title ?? "",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/circle_logo.png',
              height: 40,
            ),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8031CC), Color.fromARGB(255, 106, 6, 145)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/circle_logo.png"),
            ),
            SizedBox(height: 20),
            if (!_isDogWalkerVerifier()) ...[
              _buildListTile(0, 'Proizvodi', 'assets/icons/products.png', () {
                _onItemTapped(0);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              }),
              _buildListTile(1, 'Korisnici', 'assets/icons/users.png', () {
                _onItemTapped(1);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserListScreen(),
                  ),
                );
              }),
              _buildListTile(2, 'Forum postovi', 'assets/icons/forum_posts.png',
                  () {
                _onItemTapped(2);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ForumPostListScreen(),
                  ),
                );
              }),
              _buildListTile(3, 'Narudžbe', 'assets/icons/orders.png', () {
                _onItemTapped(3);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const OrderListScreen(),
                  ),
                );
              }),
              _buildListTile(4, 'Izvještaji', 'assets/icons/reports.png', () {
                _onItemTapped(4);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ReportsScreen(),
                  ),
                );
              }),
            ] else ...[
              _buildListTile(5, 'Šetači', 'assets/icons/reports.png', () {
                _onItemTapped(5);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DogWalkersListScreen(),
                  ),
                );
              }),
            ],
            SizedBox(height: 70),
            Padding(
              padding: EdgeInsets.all(32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 53, 3, 61),
                      Color.fromARGB(255, 10, 77, 119)
                    ])),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(20),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/sign_out.png',
                        height: 20,
                      ),
                      SizedBox(width: 20), // Spacer
                      Text(
                        "Odjava",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ), // Text
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                opacity: AlwaysStoppedAnimation(.3),
              ),
            ),
            SafeArea(
              child: widget.child!
            ),
          ],
        ),
    );
  }

  Widget _buildListTile(
      int index, String title, String leadingImage, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: _selectedIndex == index
            ? LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.5),
                  Colors.blue.withOpacity(0.8)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  _selectedIndex == index ? Colors.white : Color(0xFF8031CC)),
        ),
        onTap: () {
          _onItemTapped(index);
          onTap();
        },
        horizontalTitleGap: 14.0,
        leading: Image.asset(
          leadingImage,
          height: 36,
        ),
        shape: Border(bottom: BorderSide(color: Colors.purple, width: 0.2)),
      ),
    );
  }

  int _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    return _selectedIndex;
  }

   bool _isDogWalkerVerifier() {
    return user?.userRoles?.any((role) => role.role?.name == "DogWalkerVerifier") ??
        false;
  }
}
