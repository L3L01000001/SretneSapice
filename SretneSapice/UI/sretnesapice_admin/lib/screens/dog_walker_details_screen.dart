import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sretnesapice_admin/models/dog_walker.dart';
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
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ime: ${widget.dogWalker.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Prezime: ${widget.dogWalker.surname}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Godine: ${widget.dogWalker.age}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Telefon: ${widget.dogWalker.phone}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Iskustvo: ${widget.dogWalker.experience}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              widget.dogWalker.dogWalkerPhoto != null &&
                      widget.dogWalker.dogWalkerPhoto!.isNotEmpty
                  ? Image.memory(base64Decode(widget.dogWalker.dogWalkerPhoto!))
                  : Text('Nema slike', style: TextStyle(fontSize: 18)),
            ],
          ),
        ));
  }
}
