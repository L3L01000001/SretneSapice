import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/models/service_request.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest serviceRequest;

  const ServiceRequestCard({Key? key, required this.serviceRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getCardColor(serviceRequest.status ?? "Pending"),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${serviceRequest.date}'),
                  Text('Od: ${serviceRequest.startTime}'),
                  Text('Do: ${serviceRequest.endTime}'),
                  Text('Pasmina: ${serviceRequest.dogBreed}'),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement accept logic
                  },
                  child: Text('Accept'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement reject logic
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey; // Default color if status is unknown
    }
  }
}