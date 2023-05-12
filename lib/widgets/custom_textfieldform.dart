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
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        labelText: label,
        labelStyle: const TextStyle(
          color: primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            //make the border color black
            color: primaryColor,
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white70,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            //make the border color black
            color: primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusColor: primaryColor,
        fillColor: primaryColor,
      ),
      controller: controller,
      onChanged: (value) => onChanged(value),
      validator: (value) => validator(value),
    );
  }
}
