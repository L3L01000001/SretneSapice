import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/service_request.dart';
import 'package:sretnesapice_mobile/providers/service_request_provider.dart';
import 'package:sretnesapice_mobile/widgets/master_screen.dart';
import 'package:sretnesapice_mobile/widgets/service_request_card.dart';

class ServiceRequestListScreen extends StatefulWidget {
  static const String routeName = "/service-requests";
  int id;
  ServiceRequestListScreen({super.key, required this.id});

  @override
  State<ServiceRequestListScreen> createState() =>
      _ServiceRequestListScreenState();
}

class _ServiceRequestListScreenState extends State<ServiceRequestListScreen> {
  ServiceRequestProvider? _serviceRequestProvider = null;
  List<ServiceRequest> serviceRequests = [];
  bool loading = false;

  final int selectedIndex = 3;

  String? selectedSort;

  @override
  void initState() {
    super.initState();
    _serviceRequestProvider = context.read<ServiceRequestProvider>();

    loadData();
  }

  Future loadData() async {
    setState(() {
      loading = true;
    });

    try {
      List<ServiceRequest> tmpData = await _serviceRequestProvider!
          .getServiceRequestsByWalkerId(widget.id);

      setState(() {
        serviceRequests = tmpData;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void sortRequests(String sortOption) {
    setState(() {
      selectedSort = sortOption;
      if (sortOption == 'Pending') {
        serviceRequests.sort((a, b) => a.status == 'Pending' ? -1 : 1);
      } else if (sortOption == 'Accepted') {
        serviceRequests.sort((a, b) => a.status == 'Accepted' ? -1 : 1);
      } else if (sortOption == 'Rejected') {
        serviceRequests.sort((a, b) => a.status == 'Rejected' ? -1 : 1);
      } else if (sortOption == 'Finished') {
        serviceRequests.sort((a, b) => a.status == 'Finished' ? -1 : 1);
      }
    });
  }

  Future<void> handleAccept(ServiceRequest serviceRequest) async {
    await _serviceRequestProvider!
        .acceptServiceRequest(serviceRequest.serviceRequestId!);

    loadData();
  }

  Future<void> handleReject(ServiceRequest serviceRequest) async {
    await _serviceRequestProvider!
        .rejectServiceRequest(serviceRequest.serviceRequestId!);

    loadData();
  }

  Future<void> handleFinish(ServiceRequest serviceRequest) async {
    await _serviceRequestProvider!
        .finishServiceRequest(serviceRequest.serviceRequestId!);

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      initialIndex: selectedIndex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: Color(0xff1590a1),
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DropdownButton<String>(
                underline: SizedBox(),
                value: selectedSort,
                hint: Text("Sortiraj po statusu",
                    style: TextStyle(color: Colors.white)),
                items: <String>['Pending', 'Accepted', 'Rejected', 'Finished']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    sortRequests(newValue);
                  }
                },
                iconDisabledColor: Colors.white,
                iconEnabledColor: Colors.white,
                selectedItemBuilder: (BuildContext context) {
                  return <String>['Pending', 'Accepted', 'Rejected', 'Finished']
                      .map<Widget>((String value) {
                    return Center(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          Expanded(
            child: loading
                ? _buildLoadingIndicator()
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: ListView.builder(
                      itemCount: serviceRequests.length,
                      itemBuilder: (context, index) {
                        return ServiceRequestCard(
                            serviceRequest: serviceRequests[index],
                            onAccept: () =>
                                handleAccept(serviceRequests[index]),
                            onReject: () =>
                                handleReject(serviceRequests[index]),
                            onFinish: () =>
                                handleFinish(serviceRequests[index]));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
