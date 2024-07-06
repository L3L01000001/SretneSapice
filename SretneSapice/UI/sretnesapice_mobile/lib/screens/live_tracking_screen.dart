import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/dog_walker_location.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

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

  final int selectedIndex = 3;

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
      print('Greška: $e');
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
    return MasterScreenWidget(
      initialIndex: selectedIndex,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: walkerLocation != null
                    ? FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              _userPosition.latitude, _userPosition.longitude),
                          initialZoom: 14,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80,
                                height: 80,
                                point: LatLng(_userPosition.latitude,
                                    _userPosition.longitude),
                                child: Container(
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                              ),
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(_dogWalkerPosition.latitude,
                                    _dogWalkerPosition.longitude),
                                child: Container(
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
