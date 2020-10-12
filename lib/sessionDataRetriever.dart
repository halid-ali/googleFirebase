import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class SessionDataRetriever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: FlutterSession().get('userData'),
        builder: (context, snapshot) {
          return Text(snapshot.hasData
              ? snapshot.data['uid'] + ' | ' + snapshot.data['email']
              : 'Loading');
        },
      ),
    );
  }
}
