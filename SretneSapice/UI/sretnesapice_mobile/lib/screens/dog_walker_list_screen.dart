import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/favorite_walker.dart';
import 'package:sretnesapice_mobile/models/user.dart';
import 'package:sretnesapice_mobile/providers/city_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/favorite_walker_provider.dart';
import 'package:sretnesapice_mobile/requests/favorite_walker_request.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_application_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/dog_walker_card.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';

class DogWalkerListScreen extends StatefulWidget {
  static const String routeName = "/dogwalkers";
  final bool showOnlyFavorites;
  const DogWalkerListScreen({super.key, this.showOnlyFavorites = false});

  @override
  State<DogWalkerListScreen> createState() => _DogWalkerListScreenState();
}

class _DogWalkerListScreenState extends State<DogWalkerListScreen> {
  final int selectedIndex = 1;
  DogWalkerProvider? _dogWalkerProvider = null;
  CityProvider? _cityProvider = null;
  FavoriteWalkerProvider? _favoriteWalkerProvider = null;

  List<DogWalker> data = [];
  TextEditingController _searchController = TextEditingController();
  String? _selectedSortingOption;

  City? selectedCity;
  List<City> cities = [];
  List<FavoriteWalker> favoriteWalkerIds = [];

  User? user = Authorization.user;

  bool loading = false;

  FavoriteWalkerRequest favoriteWalkerRequest = new FavoriteWalkerRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _cityProvider = context.read<CityProvider>();
    _favoriteWalkerProvider = context.read<FavoriteWalkerProvider>();

    loadData();
  }

  Future loadData() async {
    loading = true;
    try {
      var dwData = await _dogWalkerProvider?.get({'isApproved': true});
      var citiesData = await _cityProvider?.get();
      var fwData = await _favoriteWalkerProvider?.get({'userId': user!.userId});

      setState(() {
        data = dwData!;
        cities = citiesData!;
        favoriteWalkerIds = fwData!;
      });
      loading = false;
    } on Exception catch (e) {
      errorDialog(context, e);
    }
  }

  void toggleFavoriteStatus(int dogWalkerId) async {
    try {
      if (isFavoriteWalker(dogWalkerId)) {
        final favoriteWalker = favoriteWalkerIds.firstWhere(
            (favoriteWalker) => favoriteWalker.dogWalkerId == dogWalkerId);

        if (favoriteWalker != null) {
          await _favoriteWalkerProvider
              ?.hardDelete(favoriteWalker.favoriteWalkerId!);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text("Nešto je pošlo po zlu! Nemoguće obaviti akciju."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                )
              ],
            ),
          );
        }
      } else {
        favoriteWalkerRequest.dogWalkerId = dogWalkerId;
        await _favoriteWalkerProvider?.insert!(favoriteWalkerRequest);
      }
      loadData();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: selectedIndex,
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
                        SizedBox(width: 5.0),
                        _buildLocationDropdown(),
                      ],
                    ),
                  ),
                  loading
                      ? Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Center(child: CircularProgressIndicator()))
                      : Padding(
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
      height: 40,
      child: DropdownButton<String>(
        underline: SizedBox(),
        hint: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'Sortiraj po',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        dropdownColor: Color(0xff09424a),
        iconDisabledColor: Colors.white,
        iconEnabledColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        value: _selectedSortingOption,
        onChanged: (String? newValue) async {
          setState(() {
            _selectedSortingOption = newValue!;
          });

          try {
            if (_selectedSortingOption == 'Najviše dojmova') {
              var tmpdata =
                  await _dogWalkerProvider?.get({'mostReviews': true});
              setState(() {
                data = tmpdata!;
              });
            } else if (_selectedSortingOption == 'Najbolji rating') {
              var tmpData = await _dogWalkerProvider?.get({'bestRating': true});
              setState(() {
                data = tmpData!;
              });
            } else if (_selectedSortingOption == 'Najviše usluga') {
              var tmpdata =
                  await _dogWalkerProvider?.get({'mostFinishedServices': true});
              setState(() {
                data = tmpdata!;
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
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff09424a),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15)),
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

    List<DogWalker> filteredData = widget!.showOnlyFavorites
        ? data.where((dW) => isFavoriteWalker(dW.dogWalkerId)).toList()
        : data;

    return filteredData.map((dW) {
      return DogWalkerCard(
        fullName: dW.fullName,
        city: dW.city?.name,
        photo: dW.dogWalkerPhoto,
        dogWalkerId: dW.dogWalkerId,
        isFavorite: isFavoriteWalker(dW.dogWalkerId),
        onFavoriteToggled: (isFavorite) {
          toggleFavoriteStatus(dW.dogWalkerId!);
        },
      );
    }).toList();
  }

  bool _isDogWalkerAlready() {
    return user?.userRoles?.any((role) => role.role?.name == "DogWalker") ??
        false;
  }

  bool isFavoriteWalker(int? dogWalkerId) {
    return favoriteWalkerIds
        .any((favoriteWalker) => favoriteWalker.dogWalkerId == dogWalkerId);
  }
}
