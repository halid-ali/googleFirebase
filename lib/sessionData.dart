import 'package:googleFirebase/login/loginMethod.dart';

class SessionData {
  final String email;
  final String uid;
  final LoginMethod loginMethod;

  SessionData(this.email, this.uid, this.loginMethod);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['uid'] = uid;
    data['method'] = loginMethod.toString();

    return data;
  }
}
