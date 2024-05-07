import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/product_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  MasterScreenWidget({this.child, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.pushNamed(context, ForumPostListScreen.routeName);
    } else if (currentIndex == 1) {
      
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: widget.child!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/forum_posts.png', width: 35, height: 35),
            label: 'FORUM',
            
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/dog-walking.png', width: 35, height: 35),
            label: 'ŠETAČI',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/products.png', width: 35, height: 35),
            label: 'SHOP',
            
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/settings.png', width: 35, height: 35),
            label: 'POSTAVKE',
          )
        ],
        
        selectedItemColor: Colors.purple[800],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
      
    );
  }
}
