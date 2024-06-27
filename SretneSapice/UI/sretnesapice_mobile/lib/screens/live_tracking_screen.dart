import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/dog_walker_location.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_location_provider.dart';

class LiveTrackingScreen extends StatefulWidget {
  static const String routeName = "/live-tracking";
  final int dogWalker;

  const LiveTrackingScreen({super.key, required this.dogWalker});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late Position _userPosition;
  late Position _dogWalkerPosition;

  DogWalkerLocationProvider? _dogWalkerLocationProvider = null;
  DogWalkerLocation? walkerLocation;

  @override
  void initState() {
    super.initState();
    _dogWalkerLocationProvider = context.read<DogWalkerLocationProvider>();

    _fetchPositions();
  }

  Future<void> _fetchPositions() async {
    try {
      _userPosition = await _fetchUserPosition();

      walkerLocation =
          await _dogWalkerLocationProvider!.getById(widget.dogWalker);

      if (walkerLocation != null &&
          walkerLocation!.latitude != null &&
          walkerLocation!.longitude != null) {
        _dogWalkerPosition = Position(
          timestamp: walkerLocation!.timestamp!,
          latitude: walkerLocation!.latitude!,
          longitude: walkerLocation!.longitude!,
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      }

      setState(() {});
    } catch (e) {
      print('Error fetching positions: $e');
    }
  }

  Future<Position> _fetchUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Greska.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  /* GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          _userPosition.latitude, _userPosition.longitude),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('user'),
                        position: LatLng(
                            _userPosition.latitude, _userPosition.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(title: 'Your Location'),
                      ),
                      Marker(
                        markerId: MarkerId('dogWalker'),
                        position: LatLng(_dogWalkerPosition.latitude, _dogWalkerPosition.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(title: 'Dog Walker\'s Location'),
                      ), 
                    },
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
