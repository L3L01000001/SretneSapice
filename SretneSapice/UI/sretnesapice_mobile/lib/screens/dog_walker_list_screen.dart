import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_application_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/dog_walker_card.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class DogWalkerListScreen extends StatefulWidget {
  static const String routeName = "/dogwalkers";
  const DogWalkerListScreen({super.key});

  @override
  State<DogWalkerListScreen> createState() => _DogWalkerListScreenState();
}

class _DogWalkerListScreenState extends State<DogWalkerListScreen> {
  DogWalkerProvider? _dogWalkerProvider = null;
  CityProvider? _cityProvider = null;

  List<DogWalker> data = [];
  TextEditingController _searchController = TextEditingController();
  String? _selectedSortingOption;

  City? selectedCity;
  List<City> cities = [];

  User? user = Authorization.user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _cityProvider = context.read<CityProvider>();

    loadData();
  }

  Future loadData() async {
    var dwData = await _dogWalkerProvider?.get({'isApproved': true});
    var citiesData = await _cityProvider?.get();

    setState(() {
      data = dwData!;
      cities = citiesData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDogWalkerSearch(),
                  Padding(
                     padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSortingDropdown(),
                          SizedBox(
                              width:
                                  5.0), // Add some spacing between the dropdowns
                          _buildLocationDropdown(),
                        ],
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: _buildDogWalkerCardList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_isDogWalkerAlready())
            Positioned(
              width: 260,
              height: 42,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DogWalkerApplicationScreen(),
                    ),
                  );
                },
                backgroundColor: (Color(0xff09424a)),
                child: Text(
                  "Želiš postati šetač?",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDogWalkerSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) async {
                var tmpData =
                    await _dogWalkerProvider?.get({'fullName': value});
                setState(() {
                  data = tmpData!;
                });
              },
              decoration: InputDecoration(
                  hintText: "Pretraga",
                  hintStyle: TextStyle(color: Color(0xff09424a)),
                  labelStyle: TextStyle(color: Color(0xff09424a)),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      'assets/icons/search-icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xff1590a1)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff1590a1)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Color(0xff1590a1),
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 50,
      child: DropdownButton<String>(
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Sortiraj po:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff09424a)),
        borderRadius: BorderRadius.circular(10),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Najviše dojmova') {
              var tmpdata =
                  await _dogWalkerProvider!.getDogWalkersWithMostReviewsFirst();
              setState(() {
                data = tmpdata;
              });
            } else if (_selectedSortingOption == 'Najbolji rating') {
              var tmpData = await _dogWalkerProvider?.get({'bestRating': true});
              setState(() {
                data = tmpData!;
              });
            } else if (_selectedSortingOption == 'Najviše usluga') {
              var tmpdata = await _dogWalkerProvider!
                  .getDogWalkersWithMostFinishedServicesFirst();
              setState(() {
                data = tmpdata;
              });
            } else {
              print('Invalid sorting option');
            }
          } catch (error) {
            print('Error fetching products: $error');
          }
        },
        items: <String>[
          'Preporučeno',
          'Najviše dojmova',
          'Nabolji rating',
          'Najviše usluga'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.center,
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      cities.isNotEmpty
          ? Container(
              width: 130,
              height: 40,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                //borderRadius: BorderRadius.circular(20),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff09424a),
                  ),
                ),
              ),
              child: DropdownButton<City>(
                isExpanded: true,
                underline: Container(),
                value: selectedCity,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text(
                  'Grad',
                  style: TextStyle(
                      color: Color(0xff09424a),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                elevation: 16,
                borderRadius: BorderRadius.circular(5),
                onChanged: (City? value) async {
                  setState(() {
                    selectedCity = value;
                  });
                  var tmpdata = await _dogWalkerProvider!
                      .get({'cityID': selectedCity?.cityID});
                  setState(() {
                    data = tmpdata;
                  });
                },
                items: cities
                        .map((city) => DropdownMenuItem<City>(
                              alignment: AlignmentDirectional.center,
                              value: city,
                              child: Text(city.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Color(0xff09424a))),
                            ))
                        .toList() ??
                    [],
              ),
            )
          : Container(),
    ]);
  }

  List<Widget> _buildDogWalkerCardList() {
    if (data.length == 0) {
      return [];
    }
    return data.map((dW) {
      return DogWalkerCard(
        fullName: dW.fullName,
        city: dW.city?.name,
        photo: dW.dogWalkerPhoto,
        dogWalkerId: dW.dogWalkerId,
      );
    }).toList();
  }

  bool _isDogWalkerAlready() {
    return user?.userRoles?.any((role) => role.role?.name == "DogWalker") ??
        false;
  }
}
