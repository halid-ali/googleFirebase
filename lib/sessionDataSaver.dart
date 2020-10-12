import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:googleFirebase/sessionData.dart';

class SessionDataSaver extends StatelessWidget {
  final SessionData sessionData;

  SessionDataSaver(this.sessionData);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: saveSession(context),
        builder: (context, snapshot) {
          return Text('You will not see this');
        },
      ),
    );
  }

  Future<void> saveSession(context) async {
    await FlutterSession().set('userData', sessionData);
    Navigator.push(context, MaterialPageRoute(builder: (context) => null));
  }
}
