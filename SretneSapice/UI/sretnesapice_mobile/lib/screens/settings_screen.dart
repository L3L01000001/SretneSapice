import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:background_location/background_location.dart';
import 'package:sretnesapice_mobile/main.dart';
import 'package:sretnesapice_mobile/models/service_request.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_location_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/service_request_provider.dart';
import 'package:sretnesapice_mobile/providers/user_provider.dart';
import 'package:sretnesapice_mobile/requests/dog_walker_location_request.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/screens/edit_profile_screen.dart';
import 'package:sretnesapice_mobile/screens/forum_post_list_screen.dart';
import 'package:sretnesapice_mobile/screens/live_tracking_screen.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/screens/service_request_list_screen.dart';
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
  ServiceRequestProvider? _serviceRequestProvider = null;
  DogWalkerLocationProvider? _dogWalkerLocationProvider = null;
  UserProvider? _userProvider;
  int userId = Authorization.user!.userId;
  User? loggedInUser;

  final String? profilePhotoBase64 = Authorization.user!.profilePhoto ?? null;
  bool hasAppliedToBeDogWalker = false;
  String dogWalkerStatus = "Unknown";

  final int selectedIndex = 3;

  int dogWalkerId = 0;
  List<ServiceRequest> activeServiceRequests = [];

  DogWalkerLocationRequest dogWalkerLocationRequest =
      new DogWalkerLocationRequest();

  @override
  void initState() {
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _userProvider = context.read<UserProvider>();
    _serviceRequestProvider = context.read<ServiceRequestProvider>();
    _dogWalkerLocationProvider = context.read<DogWalkerLocationProvider>();

    getUser();
    loadData();
    initBackgroundLocationService();
    _getDogWalkerStatusByUserId();
  }

  Future<void> initBackgroundLocationService() async {
    try {
      await BackgroundLocation.startLocationService();

      await BackgroundLocation.setAndroidNotification(
        title: 'Background Location',
        message: 'Tracking location in the background',
      );

      BackgroundLocation.getLocationUpdates((location) {
         _sendLocationToBackend(location.latitude, location.longitude); 
      });
    } catch (e) {
      print('Error initializing background location: $e');
    }
  }

  Future<void> _sendLocationToBackend(
      double? latitude, double? longitude) async {
    if (dogWalkerId != 0) {
      dogWalkerLocationRequest.dogWalkerId = dogWalkerId;
      dogWalkerLocationRequest.latitude = latitude;
      dogWalkerLocationRequest.longitude = longitude;
      dogWalkerLocationRequest.timestamp = DateTime.now();

      try {
        if (_dogWalkerLocationProvider != null) {
          bool exists = await _dogWalkerLocationProvider!
              .dogWalkerExistsInTable(dogWalkerId);

          if (exists) {
            await _dogWalkerLocationProvider!.update(
                dogWalkerLocationRequest.dogWalkerId!,
                dogWalkerLocationRequest);
            print('Location updated successfully');
          } else {
            await _dogWalkerLocationProvider!.insert(dogWalkerLocationRequest);
            print('Location inserted successfully');
          }
        } else {
          print('Error: _dogWalkerLocationProvider is null');
        }
      } catch (e) {
        print('Error sending location: $e');
      }
    } else {
      print('Invalid dogWalkerId: $dogWalkerId');
    }
  }

  Future getUser() async {
    var userData = await _userProvider?.getById(userId);

    setState(() {
      this.loggedInUser = userData;
    });
  }

  Future loadData() async {
    try {
      final hasApplied =
          await _dogWalkerProvider!.checkDogWalkerApplicationStatus(userId);

      var id = await _dogWalkerProvider!.getDogWalkerIdByUserId(userId);

      List<ServiceRequest> acceptedServices = [];
      try {
        acceptedServices =
            await _serviceRequestProvider!.getServiceRequestsByLoggedInUser();
      } catch (e) {
        print('No active service requests found: $e');
      }

      acceptedServices ??= [];

      setState(() {
        hasAppliedToBeDogWalker = hasApplied;
        this.dogWalkerId = id;
        this.activeServiceRequests = acceptedServices;
      });
    } catch (e) {
      print('Error checking application status: $e');
    }
  }

  Future<void> _getDogWalkerStatusByUserId() async {
    try {
      final status =
          await _dogWalkerProvider!.getDogWalkerStatusByUserId(userId);
      setState(() {
        dogWalkerStatus = _translateStatus(status);
      });
    } catch (e) {
      print('Error checking application status: $e');
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'Approved':
        return 'Odobren';
      case 'Rejected':
        return 'Odbijen';
      case 'Pending':
        return 'Na čekanju';
      default:
        return 'Nepoznat';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Odobren':
        return Colors.green;
      case 'Odbijen':
        return Colors.red;
      case 'Na čekanju':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: selectedIndex,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumPostListScreen(
                          userId: Authorization.user!.userId,
                        ),
                      ),
                    );
                  },
                ),
                if (hasAppliedToBeDogWalker)
                  _buildListTile(
                    title: "Status šetač prijave",
                    icon: Icons.assignment_turned_in,
                    subtitle: dogWalkerStatus,
                    onTap: () {},
                  ),
                if (_isDogWalker())
                  _buildListTile(
                    title: "Zahtjevi za usluge",
                    icon: Icons.assignment,
                    onTap: () {
                      if (dogWalkerId != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ServiceRequestListScreen(id: dogWalkerId),
                          ),
                        );
                      }
                    },
                  ),
                _buildListTile(
                  title: "Omiljeni šetači",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DogWalkerListScreen(showOnlyFavorites: true),
                      ),
                    );
                  },
                ),
                ..._buildActiveServiceListTiles(),
                _buildListTile(
                  title: "Odjava",
                  icon: Icons.logout,
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
      child: loggedInUser == null
          ? Container(
              height: 150,
              child:
                  Center(child: CircularProgressIndicator(color: Colors.white)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: loggedInUser!.profilePhoto != ""
                          ? MemoryImage(
                              base64Decode(loggedInUser!.profilePhoto!))
                          : null,
                      child: loggedInUser?.profilePhoto == ""
                          ? Icon(Icons.person, size: 40)
                          : null),
                  SizedBox(width: 26),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loggedInUser?.fullName ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        loggedInUser?.city?.name ?? "Nema",
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
      String? subtitle,
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
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Color(0xff52297a), fontSize: 18),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(color: _getStatusColor(subtitle)),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  List<Widget> _buildActiveServiceListTiles() {
    return activeServiceRequests.map((service) {
      return _buildListTile(
        title: "Provjeri lokaciju šetača (${service.dogWalker?.name})",
        icon: Icons.location_on,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LiveTrackingScreen(dogWalker: service.dogWalkerId!),
            ),
          );
        },
      );
    }).toList();
  }

  bool _isDogWalker() {
    return Authorization.user?.userRoles
            ?.any((role) => role.role?.name == "DogWalker") ??
        false;
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
