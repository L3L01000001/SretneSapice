import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/screens/cart_screen.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/fromToDo4924.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';
import 'package:sretnesapice_mobile/screens/settings_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final int initialIndex;
  MasterScreenWidget({this.child, this.initialIndex = 0, Key? key})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pushNamed(
      context,
      _getRouteName(index),
      arguments: index,
    );
  }

  String _getRouteName(int index) {
    switch (index) {
      case 0:
        return ForumPostListScreen.routeName;
      case 1:
        return FromToDo4924ListScreen.routeName;
      case 2:
        return ProductListScreen.routeName;
      case 3:
        return SettingsScreen.routeName;
      default:
        return ForumPostListScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: Colors.white,
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
                icon:
                    Image.asset('assets/icons/cart.png', width: 30, height: 30),
                onPressed: () async {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              )
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
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) =>
                  states.contains(MaterialState.selected)
                      ? const TextStyle(
                          color: Color(0xff52297a),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: Color.fromARGB(255, 129, 88, 158),
                          fontSize: 18),
            ),
          ),
          child: _buildBottomBar(),
        ));
  }

  NavigationBar _buildBottomBar() {
    return NavigationBar(
      onDestinationSelected: _onItemTapped,
      destinations: <Widget>[
        NavigationDestination(
          icon:
              Image.asset('assets/icons/dog-house.png', width: 35, height: 35),
          label: 'FORUM',
        ),
        NavigationDestination(
          icon: Image.asset('assets/icons/walking-the-dog.png',
              width: 35, height: 35),
          label: 'ŠETAČI',
        ),
        NavigationDestination(
          icon: Image.asset('assets/icons/shop.png', width: 35, height: 35),
          label: 'SHOP',
        ),
        NavigationDestination(
          icon: Image.asset('assets/icons/user.png', width: 35, height: 35),
          label: 'PROFIL',
        ),
      ],
      indicatorColor: Colors.transparent,
      selectedIndex: _currentIndex,
    );
  }
}
