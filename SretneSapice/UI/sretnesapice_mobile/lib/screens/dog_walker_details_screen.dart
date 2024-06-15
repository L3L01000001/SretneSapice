import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class DogWalkerDetailsScreen extends StatefulWidget {
  static const String routeName = '/dog-walker';
  String id;
  DogWalkerDetailsScreen(this.id, {super.key});

  @override
  State<DogWalkerDetailsScreen> createState() => _DogWalkerDetailsScreenState();
}

class _DogWalkerDetailsScreenState extends State<DogWalkerDetailsScreen> {
  DogWalkerProvider? _dogWalkerProvider;

  DogWalker? dogWalker;

  @override
  void initState() {
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();

    loadData();
  }

  Future loadData() async {
    var dogWalker = await _dogWalkerProvider!.getById(int.parse(widget.id));

    setState(() {
      this.dogWalker = dogWalker;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dogWalker == null) {
      loadData();
      return LoadingScreen();
    } else {
      return MasterScreenWidget(
        child: Stack(children: [
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                _buildDogWalkerCard(),
                _buildInfoLine(),
                _buildDogWalkerInfo()
              ]),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff09424a), 
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    "Kontaktiraj",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff09424a), 
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    "Termini",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    }
  }

  Widget _buildDogWalkerCard() {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
                radius: 72,
                child: dogWalker!.dogWalkerPhoto != ""
                    ? imageFromBase64String(dogWalker!.dogWalkerPhoto!)
                    : Icon(Icons.person, size: 82)),
            SizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dogWalker!.fullName!,
                  style: TextStyle(color: Color(0xff1590a1), fontSize: 30),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 96,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1590a1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dogWalker!.city?.name ?? "Nema",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLine() {
    return Container(
      height: 70,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            Text(
              "DOJMOVI",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ]),
          Column(children: [
            Text(
              "BROJ USLUGA",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ]),
          Column(children: [
            Text(
              "RATING",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ])
        ],
      ),
    );
  }

  Widget _buildDogWalkerInfo() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          height: 250,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("Godine: ${dogWalker?.age.toString() ?? "g"}",
            style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xff09424a))),
            Text("Telefon: ${dogWalker?.phone ?? "g"}",
            style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xff09424a))),
            Text("Iskustvo: ${dogWalker?.experience ?? "g"}",
            style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xff09424a))),
          ])),
    );
  }
}
