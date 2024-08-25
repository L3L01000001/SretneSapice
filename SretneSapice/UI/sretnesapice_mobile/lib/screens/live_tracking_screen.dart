import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/dog_walker_location.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  static const String routeName = "/live-tracking";
  final int dogWalker;

  const LiveTrackingScreen({super.key, required this.dogWalker});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  Position? _userPosition;
  Position? _dogWalkerPosition;

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
      Position user = await _fetchUserPosition();

      DogWalkerLocation? walkerLocation =
          await _dogWalkerLocationProvider!.getById(widget.dogWalker);

      if (walkerLocation != null &&
          walkerLocation.latitude != null &&
          walkerLocation.longitude != null) {
        _dogWalkerPosition = Position(
          timestamp: walkerLocation.timestamp!,
          latitude: walkerLocation.latitude!,
          longitude: walkerLocation.longitude!,
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      }

      setState(() {
        this._userPosition = user;
        this._dogWalkerPosition = _dogWalkerPosition;
        this.walkerLocation = walkerLocation;
      });
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

    Position user = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: selectedIndex,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            _buildDogWalkerCard(),
            Expanded(
              child: Center(
                child: _dogWalkerPosition != null
                    ? FlutterMap(
                        options: MapOptions(
                          center: LatLng(_userPosition!.latitude,
                              _userPosition!.longitude),
                          zoom: 14,
                        ),
                        children: [
                          TileLayer(
                              urlTemplate:
                                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                              additionalOptions: {
                                'accessToken':
                                    'pk.eyJ1IjoibGVqbGFhIiwiYSI6ImNsejh2M2hueDAxbW0ybXM3bzhtbDl2MXAifQ.4csFjEDrPm6eO7NL4PTwDA',
                                'id': 'mapbox/streets-v11',
                              }),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80,
                                height: 80,
                                point: LatLng(_userPosition!.latitude,
                                    _userPosition!.longitude),
                                builder: (ctx) => Container(
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
                                point: LatLng(_dogWalkerPosition!.latitude,
                                    _dogWalkerPosition!.longitude),
                                builder: (ctx) => Container(
                                  child: Image.asset(
                                      'assets/icons/walking-the-dog.png',
                                      width: 40,
                                      height: 40),
                                ),
                              ),
                            ],
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: [
                                  LatLng(_userPosition!.latitude,
                                      _userPosition!.longitude),
                                  LatLng(_dogWalkerPosition!.latitude,
                                      _dogWalkerPosition!.longitude),
                                ],
                                strokeWidth: 4.0,
                                color: Colors.green,
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

  Widget _buildDogWalkerCard() {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: walkerLocation == null
          ? Container(
              height: 150, child: Center(child: CircularProgressIndicator()))
          : Container(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 52,
                          child: walkerLocation!.dogWalker!.dogWalkerPhoto != ""
                              ? imageFromBase64String(
                                  walkerLocation!.dogWalker!.dogWalkerPhoto!)
                              : Icon(Icons.person, size: 52)),
                      SizedBox(width: 10),
                      Text(
                        walkerLocation!.dogWalker!.fullName! ?? "Nema",
                        style:
                            TextStyle(color: Color(0xff1590a1), fontSize: 30),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff1590a1),
                          Color(0xff31bacc),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("LOKACIJA",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
