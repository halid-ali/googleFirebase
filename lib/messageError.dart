import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  ErrorMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 21, color: Colors.red),
    );
  }
}
