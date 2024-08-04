import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/dog_walker_availability.dart';
import 'package:sretnesapice_mobile/providers/availability_provider.dart';
import 'package:sretnesapice_mobile/providers/dog_walker_provider.dart';
import 'package:sretnesapice_mobile/providers/service_request_provider.dart';
import 'package:sretnesapice_mobile/providers/walker_review_provider.dart';
import 'package:sretnesapice_mobile/requests/service_insert_request.dart';
import 'package:sretnesapice_mobile/requests/walker_review_request.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_list_screen.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/widgets/text_input_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class DogWalkerDetailsScreen extends StatefulWidget {
  static const String routeName = '/dog-walker';
  String id;
  DogWalkerDetailsScreen(this.id, {super.key});

  @override
  State<DogWalkerDetailsScreen> createState() => _DogWalkerDetailsScreenState();
}

class _DogWalkerDetailsScreenState extends State<DogWalkerDetailsScreen> {
  DogWalkerProvider? _dogWalkerProvider;
  WalkerReviewProvider? _walkerReviewProvider;
  AvailabilityProvider? _availabilityProvider;
  ServiceRequestProvider? _serviceRequestProvider;

  final int selectedIndex = 1;

  DogWalker? dogWalker;
  bool showReviews = false;
  bool addWalkerReview = false;
  bool showCalendar = false;

  bool loading = false;

  WalkerReviewRequest walkerReviewRequest = new WalkerReviewRequest();
  ServiceInsertRequest serviceRequest = new ServiceInsertRequest();

  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final DateFormat _timeFormat = DateFormat.Hm(); // 24-hour format
  final _formKey = GlobalKey<FormState>();

  List<DogWalkerAvailability> availabilities = [];

  @override
  void initState() {
    super.initState();
    _dogWalkerProvider = context.read<DogWalkerProvider>();
    _walkerReviewProvider = context.read<WalkerReviewProvider>();
    _availabilityProvider = context.read<AvailabilityProvider>();
    _serviceRequestProvider = context.read<ServiceRequestProvider>();

    loadData();
  }

  Future loadData() async {
    var dogWalker = await _dogWalkerProvider!.getById(int.parse(widget.id));
    var availabilities = await _availabilityProvider!
        .getAvailabilitiesByWalkerId(int.parse(widget.id));

    setState(() {
      this.dogWalker = dogWalker;
      this.availabilities = availabilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dogWalker == null) {
      loadData();
      return LoadingScreen();
    } else {
      return MasterScreenWidget(
        initialIndex: selectedIndex,
        child: Stack(children: [
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                _buildDogWalkerCard(),
                _buildInfoLine(),
                if (!showReviews && !showCalendar) _buildDogWalkerInfo(),
                if (showReviews) _buildWalkerReviews(),
                if (showCalendar) _buildCalendar(),
              ]),
            ),
          ),
          if (!addWalkerReview && !showCalendar)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final Uri telUri = Uri(
                        scheme: 'tel',
                        path: dogWalker?.phone!,
                      );

                      if (await canLaunchUrl(telUri)) {
                        await launchUrl(telUri);
                      } else {
                        throw 'Could not launch $telUri';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff09424a),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Kontaktiraj",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCalendar = true;
                      });

                      setState(() {
                        showReviews = false;
                      });

                      setState(() {
                        addWalkerReview = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff09424a),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    if (!showReviews && !showCalendar) {
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
    } else {
      return Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 52,
                child: dogWalker!.dogWalkerPhoto != ""
                    ? imageFromBase64String(dogWalker!.dogWalkerPhoto!)
                    : Icon(Icons.person, size: 52),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dogWalker!.fullName!,
                    style: TextStyle(color: Color(0xff1590a1), fontSize: 30),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1590a1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      dogWalker!.city?.name ?? "Nema",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: _buildRatingStars(dogWalker!.rating ?? 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildInfoLine() {
    if (showReviews) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "DOJMOVI",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                "${dogWalker!.walkerReviews?.length ?? 0}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff1590a1),
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addWalkerReview = true;
                });
              },
              child: Text("Dodaj dojam"),
            ),
          ],
        ),
      );
    } else if (showCalendar) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TERMINI",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else {
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
            GestureDetector(
              onTap: () {
                setState(() {
                  showReviews = true;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "DOJMOVI",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dogWalker!.walkerReviews?.length.toString() ?? "0",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "BROJ USLUGA",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(dogWalker!.serviceRequests?.length.toString() ?? "0",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ))
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("RATING",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  Row(
                    children: _buildRatingStars(dogWalker!.rating ?? 0),
                  )
                ])
          ],
        ),
      );
    }
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
                style: TextStyle(fontSize: 18.0, color: Color(0xff09424a))),
            Text("Telefon: ${dogWalker?.phone ?? "g"}",
                style: TextStyle(fontSize: 18.0, color: Color(0xff09424a))),
            Text("Iskustvo: ${dogWalker?.experience ?? "g"}",
                style: TextStyle(fontSize: 18.0, color: Color(0xff09424a))),
          ])),
    );
  }

  Widget _addReview() {
    int? _rating;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _reviewController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Dodaj dojam',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          walkerReviewRequest.dogWalkerId =
                              dogWalker!.dogWalkerId;
                          walkerReviewRequest.reviewText =
                              _reviewController.text;
                          walkerReviewRequest.rating = _rating;

                          var review = await _walkerReviewProvider!
                              .insert(walkerReviewRequest);

                          if (review != null) {
                            await loadData();
                          }
                        } catch (e) {
                          setState(() {
                            addWalkerReview = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Text(
                                  "Nemoguće dodati dojam ukoliko Vam ovaj šetač nije pružio usluge!"),
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
                      }
                    },
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 9, 66, 74)),
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalkerReviews() {
    List<Widget> reviewCards = [];

    if (dogWalker!.walkerReviews!.isNotEmpty) {
      for (var review in dogWalker!.walkerReviews!) {
        reviewCards.add(
          Card(
            elevation: 2,
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff1590a1), Color(0xff006371)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: review.user!.profilePhoto != ""
                              ? imageFromBase64String(
                                  review.user!.profilePhoto!)
                              : Icon(Icons.person, size: 30),
                        ),
                        SizedBox(height: 8),
                        Text(
                          review.user!.fullName ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.reviewText ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ..._buildRatingStars(review.rating ?? 0),
                              SizedBox(width: 8),
                              Text(
                                review.rating?.toString() ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      reviewCards.add(
        Center(
          child: Text("Nema dojmova"),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...reviewCards,
        if (addWalkerReview)
          Padding(padding: EdgeInsets.all(10), child: _addReview()),
      ],
    );
  }

  DateTime _focusedDay = DateTime.now();

  Widget _buildCalendar() {
    DateTime selectedDate = serviceRequest.date ?? DateTime.now();
    List<String> eventsForSelectedDay = _getEventsForDay(selectedDate);

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.now().subtract(Duration(days: 365)),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  eventLoader: _getEventsForDay,
                  availableGestures: AvailableGestures.all,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      serviceRequest.date = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  selectedDayPredicate: (day) =>
                      isSameDay(serviceRequest.date, day),
                ),
              ),
              SizedBox(height: 10),
              Text("Već zakazani termini za ovaj datum:",
                  style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 151, 28, 19))),
              SizedBox(height: 10),
              if (eventsForSelectedDay.isNotEmpty)
                Column(
                  children: eventsForSelectedDay
                      .map((event) => Card(
                            child: ListTile(
                              tileColor: const Color.fromARGB(255, 151, 28, 19),
                              title: Text(event,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ))
                      .toList(),
                ),
              SizedBox(height: 20),
              Text("Zakaži novi termin:",
                  style: TextStyle(fontSize: 18, color: Color(0xff1590a1))),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _selectTime(context, true),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff1590a1),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      serviceRequest.startTime != null
                          ? "Od: ${_timeFormat.format(serviceRequest.startTime!)}"
                          : "Odaberi od:",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () => _selectTime(context, false),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff1590a1),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                        serviceRequest.endTime != null
                            ? "Do: ${_timeFormat.format(serviceRequest.endTime!)}"
                            : "Odaberi do:",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextInputWidget(
                labelText: "Pasmina",
                controller: _breedController,
                minLength: 2,
                isEmail: false,
                isPhoneNumber: false,
                color: Color(0xff1590a1),
                maxLines: 1,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (serviceRequest.startTime != null &&
                        serviceRequest.endTime != null &&
                        serviceRequest.startTime!
                            .isAfter(serviceRequest.endTime!)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Greška"),
                          content: Text(
                              "Vrijeme početka ne može biti nakon vremena završetka."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      loading = true;
                      try {
                        serviceRequest.dogWalkerId = int.parse(widget.id);
                        serviceRequest.dogBreed = _breedController.text;

                        var serviceReq = await _serviceRequestProvider
                            ?.insert(serviceRequest);

                        loading = false;

                        if (serviceReq != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  "Uspješno ste poslali šetaču zahtjev za uslugu!",
                                  style: TextStyle(color: Color(0xff1590a1))),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.popAndPushNamed(
                                      context, DogWalkerListScreen.routeName),
                                  child: Text("Ok"),
                                )
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        loading = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Text(
                                "Nešto je pošlo po zlu. Provjerite vrijeme za početak i kraj usluge!"),
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
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff1590a1)),
                ),
                child: Text("Pošalji zahtjev za uslugu",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    List<DogWalkerAvailability> availabilitiesForDay =
        availabilities.where((availability) {
      return availability.date!.year == day.year &&
          availability.date!.month == day.month &&
          availability.date!.day == day.day;
    }).toList();

    if (availabilitiesForDay.isEmpty) {
      return ["Nema zakazanih termina za ovaj dan."];
    }

    final DateFormat timeFormat = DateFormat.Hm(); // HH:mm format

    List<String> events = availabilitiesForDay.map((availability) {
      String formattedStartTime = timeFormat.format(availability.startTime!);
      String formattedEndTime = timeFormat.format(availability.endTime!);
      return '$formattedStartTime - $formattedEndTime';
    }).toList();

    return events;
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (serviceRequest.startTime != null
              ? TimeOfDay.fromDateTime(serviceRequest.startTime!)
              : TimeOfDay(hour: 0, minute: 0))
          : (serviceRequest.endTime != null
              ? TimeOfDay.fromDateTime(serviceRequest.endTime!)
              : TimeOfDay(hour: 0, minute: 0)),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final selectedDate = serviceRequest.date ?? now;
        final dateTime = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, picked.hour, picked.minute);
        if (isStartTime) {
          serviceRequest.startTime = dateTime;
        } else {
          serviceRequest.endTime = dateTime;
        }
      });
    }
  }

  List<Widget> _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < rating; i++) {
      stars.add(Icon(
        Icons.star_outlined,
        size: 20,
        color: Colors.purple,
      ));
    }
    return stars;
  }
}
