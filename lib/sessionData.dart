class SessionData {
  final String email;
  final String uid;

  SessionData(this.email, this.uid);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['uid'] = uid;

    return data;
  }
}
