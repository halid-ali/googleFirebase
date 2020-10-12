import 'package:flutter/material.dart';
import 'package:googleFirebase/sessionDataRetriever.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Home Page'),
      ),
      body: Center(
        child: SessionDataRetriever(),
      ),
    );
  }
}
