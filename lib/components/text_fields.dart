import 'package:flutter/material.dart';

class InputDec extends StatelessWidget {
  const InputDec({Key? key}) : super(key: key);

  InputDecoration inputDec({
    String? label,
  }) {
    return InputDecoration(
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      labelText: label,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
