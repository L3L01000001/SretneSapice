import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/screens/dog_walker_details_screen.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

class DogWalkerCard extends StatelessWidget {
  final String? fullName;
  final String? city;
  final String? photo;
  final int? dogWalkerId;
  final bool isFavorite;
  final Function(bool) onFavoriteToggled;

  DogWalkerCard({
    required this.fullName,
    required this.city,
    required this.photo,
    required this.dogWalkerId,
    required this.isFavorite,
    required this.onFavoriteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, "${DogWalkerDetailsScreen.routeName}/${dogWalkerId}");
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff1590a1),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 40,
                    child: photo != ""
                        ? imageFromBase64String(photo!)
                        : Icon(Icons.person, size: 35)),
                SizedBox(width: 26),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName ?? "Nema",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Text(
                        city ?? "Nema",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1590a1),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    onFavoriteToggled(!isFavorite);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
