import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleFirebase/errorHandler.dart';
import 'package:googleFirebase/homePage.dart';
import 'package:googleFirebase/messageError.dart';
import 'package:googleFirebase/messageSuccess.dart';
import 'package:googleFirebase/registerPage.dart';
import 'package:googleFirebase/sessionData.dart';
import 'package:googleFirebase/sessionDataSaver.dart';
import 'package:googleFirebase/validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Validator validator = Validator();
  final ErrorHandler errorHandler = ErrorHandler();

  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  bool isGoogleSignIn = false;

  String _emailId;
  String _password;
  String errorMessage = '';
  String successMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Email Login'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: _formStateKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: TextFormField(
                              validator: validator.validateEmail,
                              onSaved: (value) {
                                _emailId = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailIdController,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                      style: BorderStyle.solid),
                                ),
                                labelText: 'Email Id',
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: TextFormField(
                              validator: validator.validatePassword,
                              onSaved: (value) {
                                _password = value;
                              },
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2,
                                      style: BorderStyle.solid),
                                ),
                                labelText: 'Password',
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.green),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    (errorMessage != ''
                        ? ErrorMessage(errorMessage)
                        : Container()),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => onLoginButtonPressed(),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ),
                        FlatButton(
                          onPressed: () => onRegisterButtonPressed(),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    (successMessage != ''
                        ? SuccessMessage(successMessage)
                        : Container()),
                    (!isGoogleSignIn
                        ? RaisedButton(
                            child: Text('Google Login'),
                            onPressed: onGoogleLoginPressed)
                        : RaisedButton(
                            child: Text('Google Logout'),
                            onPressed: onGoogleLogoutPressed))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      assert(result.user != null);
      assert(await result.user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(result.user.uid == currentUser.uid);

      return result.user;
    } catch (e) {
      setState(() {
        errorMessage = errorHandler.handleError(e);
      });
      return null;
    }
  }

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    FirebaseUser currentUser;

    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final AuthResult result = await auth.signInWithCredential(credential);

      assert(result.user.email != null);
      assert(result.user.displayName != null);
      assert(!result.user.isAnonymous);
      assert(await result.user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(result.user.uid == currentUser.uid);

      print(currentUser);
      print('User Name: ${currentUser.displayName}');
    } catch (e) {
      setState(() {
        errorMessage = errorHandler.handleError(e);
      });
    }

    return currentUser;
  }

  Future<bool> googleSignOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    return true;
  }

  onLoginButtonPressed() {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      signIn(_emailId, _password).then((user) {
        if (user != null) {
          print('Logged in successfully.');
          setState(() {
            SessionDataSaver(SessionData(user.email, user.uid))
                .saveSession(context);
            successMessage =
                'Logged in successfully.\nYou can now navigate to Home Page.';
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          print('Error while Email login.');
        }
      });
    }
  }

  onRegisterButtonPressed() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  onGoogleLoginPressed() {
    googleSignin(context).then((user) {
      if (user != null) {
        print('Logged in successfully.');
        setState(() {
          isGoogleSignIn = true;
          successMessage =
              'Logged in successfully.\nEmail: ${user.email}\nYou can now navigate to Home Page';
        });
      } else {
        print('Error while Google login.');
      }
    });
  }

  onGoogleLogoutPressed() {
    googleSignOut().then((response) {
      if (response) {
        setState(() {
          isGoogleSignIn = false;
          successMessage = '';
        });
      }
    });
  }
}
