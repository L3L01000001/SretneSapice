import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/models/service_request.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceRequest serviceRequest;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onFinish;

  const ServiceRequestCard({
    Key? key,
    required this.serviceRequest,
    required this.onAccept,
    required this.onReject,
    required this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      color: _getCardColor(serviceRequest.status ?? "Pending"),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Korisnik: ${serviceRequest.user?.fullName}',
                      style: TextStyle(color: Colors.white)),
                  Text(
                      '${formatDate(serviceRequest.date)} od ${formatTime(serviceRequest.startTime)} do ${formatTime(serviceRequest.endTime)}',
                      style: TextStyle(color: Colors.white)),
                  Text('Pasmina: ${serviceRequest.dogBreed}',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            serviceRequest.status == "Pending"
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: onAccept,
                        child: Text('Prihvati'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onReject,
                        child: Text('Odbij'),
                      ),
                    ],
                  )
                : Container(),
            serviceRequest.status == "Accepted"
                ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: onFinish,
                        child: Text('Završi'),
                      ),
                    ],
                  )
                : Container(),
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
      case 'Finished':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
