import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';
import 'package:sretnesapice_mobile/screens/settings_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  MasterScreenWidget({this.child, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
    if (_currentIndex == 0) {
      Navigator.pushNamed(context, ForumPostListScreen.routeName);
    } else if (_currentIndex == 1) {
      Navigator.pushNamed(context, DogWalkerListScreen.routeName);
    } else if (_currentIndex == 2) {
      Navigator.pushNamed(context, ProductListScreen.routeName);
    } else if (_currentIndex == 3) {
      Navigator.pushNamed(context, SettingsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/dog_logo.png',
                  fit: BoxFit.contain, height: 40),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  'assets/images/sretnesapice.png',
                  fit: BoxFit.contain,
                  height: 40,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20.0),
              icon: Image.asset('assets/icons/cart.png', width: 30, height: 30),
              onPressed: () {
              },
            )
          ],
        ),
      ),
     body: Stack(
        children: [
          // Background image
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
            child: Column(
              children: [
                Expanded(
                  child: widget.child ?? Container(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff663399),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/dog-house.png',
                width: 35, height: 35),
            label: 'FORUM',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/walking-the-dog.png',
                width: 35, height: 35),
            label: 'ŠETAČI',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/shop.png', width: 35, height: 35),
            label: 'SHOP',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/settings.png', width: 35, height: 35),
            label: 'POSTAVKE',
          )
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
