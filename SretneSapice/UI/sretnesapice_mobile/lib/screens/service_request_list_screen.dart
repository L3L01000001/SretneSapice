import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sretnesapice_mobile/models/service_request.dart';
import 'package:sretnesapice_mobile/providers/service_request_provider.dart';
import 'package:sretnesapice_mobile/screens/loading_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _serviceRequestProvider = context.read<ServiceRequestProvider>();

    loadData();
  }

  Future loadData() async {
    var tmpData =
        await _serviceRequestProvider!.getServiceRequestsByWalkerId(widget.id);

    setState(() {
      serviceRequests = tmpData ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: serviceRequests.length,
          itemBuilder: (context, index) {
            return ServiceRequestCard(serviceRequest: serviceRequests[index]);
          },
        ),
      ),
    );
  }
}
