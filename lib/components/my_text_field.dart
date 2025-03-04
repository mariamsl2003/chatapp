import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller; //to have access to the text
  final String hintText;
  final bool obscureText; //for hiding the text or not, if true it will be hided
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey[100],
        filled: true,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
