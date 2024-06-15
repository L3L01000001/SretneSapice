import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.minLength,
      required this.isEmail,
      required this.isPhoneNumber,
      required this.color,
      this.maxLines = 1,})
      : super(key: key);

  final TextEditingController controller;
  final String? labelText;
  final int minLength;
  final bool isEmail;
  final bool isPhoneNumber;
  final Color color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    bool password = labelText == "Lozinka" || labelText == "Potvrdi lozinku";
    RegExp phoneNumberRegex = RegExp(r'^\d{3}[\s-]\d{3}[\s-]\d{3,4}$');

    return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.fromLTRB(15, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
          border: Border(
            bottom: BorderSide(
              color: color,
            ),
          ),
        ),
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return '$labelText ne smije biti prazno!';
              } else if (minLength > 0 && value.length < minLength) {
                return '$labelText mora imat minimalno $minLength karaktera!';
              } else if (isEmail && !EmailValidator.validate(value)) {
                return '$labelText mora biti u tačnom formatu!';
              } else if (isPhoneNumber && !phoneNumberRegex.hasMatch(value)) {
                return '$labelText mora biti u formatu 061 111 111';
              }
              return null;
            },
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
            obscureText: password,
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.labelText ?? "",
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: color))));
  }
}
