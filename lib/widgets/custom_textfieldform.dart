import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function onChanged;
  final Function validator;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;

  CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.validator,
    this.contentPadding,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        labelText: label,
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            //make the border color black
            color: Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusColor: Colors.black,
        fillColor: Colors.black,
      ),
      controller: controller,
      onChanged: (value) => onChanged(value),
      validator: (value) => validator(value),
    );
  }
}
