import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class SessionDataRetriever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: FlutterSession().get('userData'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var uid = snapshot.data['uid'];
            var email = snapshot.data['email'];
            return Column(
              children: [
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 21),
                ),
                Text(
                  'UID: $uid',
                  style: TextStyle(fontSize: 21),
                ),
              ],
            );
          } else {
            return Text('Loading');
          }
        },
      ),
    );
  }
}
