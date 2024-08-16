import 'package:flutter/material.dart';
import 'package:sretnesapice_admin/models/dog_walker.dart';
import 'package:sretnesapice_admin/utils/util.dart';
import 'package:sretnesapice_admin/widgets/master_screen.dart';

class DogWalkerDetailsScreen extends StatefulWidget {
  final DogWalker dogWalker;
  const DogWalkerDetailsScreen({super.key, required this.dogWalker});

  @override
  State<DogWalkerDetailsScreen> createState() => _DogWalkerDetailsScreenState();
}

class _DogWalkerDetailsScreenState extends State<DogWalkerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        initialIndex: 5,
        title: widget.dogWalker.fullName ?? "Detalji",
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(26.0),
            child: Container(
              color: Color.fromARGB(255, 223, 212, 244),
              padding: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        color: Colors.grey[200],
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (widget.dogWalker.dogWalkerPhoto != "")
                              imageFromBase64String(
                                  widget.dogWalker.dogWalkerPhoto!)
                            else if (widget.dogWalker.dogWalkerPhoto == "")
                              Icon(Icons.account_circle,
                                  size: 100, color: Colors.grey)
                            else
                              Icon(Icons.photo, size: 100, color: Colors.grey)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ime: ${widget.dogWalker.name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Prezime: ${widget.dogWalker.surname}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Godine: ${widget.dogWalker.age}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Telefon: ${widget.dogWalker.phone}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Iskustvo: ${widget.dogWalker.experience}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Rating: ${widget.dogWalker.rating}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Grad: ${widget.dogWalker.city?.name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'SPISAK ŠETAČKIH USLUGA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  widget.dogWalker.serviceRequests != null &&
                          widget.dogWalker.serviceRequests!.isNotEmpty
                      ? Column(
                          children:
                              widget.dogWalker.serviceRequests!.map((service) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  'Početak: ${formatDate(service.startTime).toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Kraj: ${formatDate(service.endTime).toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                trailing: Text(
                                  service.status!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Text('Nema usluga.'),
                ],
              ),
            ),
          ),
        ));
  }
}
