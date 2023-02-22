import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';

// A custom text field form that has a label and a hint text.
// also has a validator to check if the input is empty or not.
// aslo has a theme that works with ios and android.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  Function onChanged;
  Function validator;

  CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // A custom text field form that has a label and a hint text.
// also has a validator to check if the input is empty or not.
// aslo has a theme that works with ios and android.
    return TextFormField(
      cursorColor: kBlue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            //make the border color black
            color: Colors.red,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusColor: Colors.black,
        fillColor: Colors.black,
      ),
      validator: (value) => validator(value),
      //TODO: check correctnes of this line
      onChanged: (value) => onChanged(value),
    );
  }
}
