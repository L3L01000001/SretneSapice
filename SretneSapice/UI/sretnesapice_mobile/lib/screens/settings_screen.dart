import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/main.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/screens/edit_profile_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DogWalkerProvider? _dogWalkerProvider = null;
  User? user = Authorization.user;
  final String? profilePhotoBase64 = Authorization.user!.profilePhoto ?? null;
  bool hasAppliedToBeDogWalker = false;
  String dogWalkerStatus = "Unknown";

  @override
  void initState() {
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _checkApplicationStatus();
    _getDogWalkerStatusByUserId();
  }

  Future<void> _checkApplicationStatus() async {
    try {
      final hasApplied = await _dogWalkerProvider!
          .checkDogWalkerApplicationStatus(user!.userId);
      setState(() {
        hasAppliedToBeDogWalker = hasApplied;
      });
    } catch (e) {
      print('Error checking application status: $e');
    }
  }

  Future<void> _getDogWalkerStatusByUserId() async {
    try {
      final status =
          await _dogWalkerProvider!.getDogWalkerStatusByUserId(user!.userId);
      print(status);
      setState(() {
        dogWalkerStatus = status;
      });
    } catch (e) {
      print('Error checking application status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            SizedBox(height: 30),
            _buildListTile(
              title: "Moji forum postovi",
              icon: Icons.forum,
              subtitle: null,
              onTap: () {},
            ),
            if (hasAppliedToBeDogWalker)
              _buildListTile(
                title: "My application status",
                icon: Icons.assignment_turned_in,
                subtitle: dogWalkerStatus,
                onTap: () {},
              ),
            if (_isDogWalker())
              _buildListTile(
                title: "Zahtjevi za usluge",
                icon: Icons.assignment,
                subtitle: null,
                onTap: () {},
              ),
            _buildListTile(
              title: "Omiljeni šetači",
              icon: Icons.favorite,
              subtitle: null,
              onTap: () {},
            ),
            _buildListTile(
              title: "Odjava",
              icon: Icons.logout,
              subtitle: null,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      color: Color(0xff52297a),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
                radius: 40,
                child: profilePhotoBase64 != ""
                    ? imageFromBase64String(profilePhotoBase64!)
                    : Icon(Icons.person, size: 40)),
            SizedBox(width: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.fullName!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  user!.city?.name ?? "Nema",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );
                  },
                  child: Text("Uredi profil"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title,
      required IconData icon,
      required String? subtitle,
      required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xff52297a)),
        title: Text(title,
            style: TextStyle(color: Color(0xff52297a), fontSize: 18)),
        subtitle:
            Text(subtitle ?? '', style: TextStyle(color: Color(0xff52297a))),
        onTap: onTap,
      ),
    );
  }

  bool _isDogWalker() {
    return user?.userRoles?.any((role) => role.role?.name == "DogWalker") ??
        false;
  }
}
