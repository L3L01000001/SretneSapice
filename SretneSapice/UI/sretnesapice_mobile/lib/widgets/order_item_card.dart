import 'package:flutter/material.dart';
import 'package:sretnesapice_mobile/utils/util.dart';

class OrderItemCard extends StatelessWidget {
  final String? name;
  final double? price;
  final String? productPhoto;
  final int? quantity;
  final Function(int) onQuantityChanged;
  final Function onDelete;

  OrderItemCard(
      {required this.name,
      required this.price,
      required this.productPhoto,
      required this.quantity,
      required this.onQuantityChanged,
      required this.onDelete,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xff315ccc),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: productPhoto != ""
                      ? imageFromBase64String(productPhoto!)
                      : Icon(Icons.photo, size: 30),
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? "",
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 35,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      formatPrice(price),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () {
                    onDelete();
                  },
                ),
                DropdownButton<int>(
                  value: quantity,
                  dropdownColor: Colors.blue,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  items: List.generate(10, (index) => index + 1)
                      .map((value) => DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onQuantityChanged(newValue);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
