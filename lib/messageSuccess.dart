import 'package:flutter/material.dart';

class SuccessMessage extends StatelessWidget {
  final String message;

  SuccessMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 21, color: Colors.green),
    );
  }
}
