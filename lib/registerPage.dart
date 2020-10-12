import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleFirebase/errorHandler.dart';
import 'package:googleFirebase/loginPage.dart';
import 'package:googleFirebase/messageError.dart';
import 'package:googleFirebase/messageSuccess.dart';
import 'package:googleFirebase/validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Validator validator = Validator();
  ErrorHandler errorHandler = ErrorHandler();

  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _passwordConfirmController = TextEditingController(text: '');

  String _emailId;
  String _password;
  String errorMessage = '';
  String successMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Firebase Email Registration'),
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
                                      style: BorderStyle.solid,
                                      width: 2),
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
                                      style: BorderStyle.solid,
                                      width: 2),
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
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: TextFormField(
                              validator: (value) {
                                return validator.validateConfirmPassword(
                                    _passwordController.text.trim(), value);
                              },
                              controller: _passwordConfirmController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                labelText: 'Confirm Password',
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                ),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                          (errorMessage != ''
                              ? ErrorMessage(errorMessage)
                              : Container()),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () => onRegisterButtonPressed(),
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ),
                              FlatButton(
                                  onPressed: () => onLoginButtonPressed(),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.blue),
                                  ))
                            ],
                          ),
                          (successMessage != ''
                              ? SuccessMessage(successMessage)
                              : Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      assert(result.user != null);
      assert(await result.user.getIdToken() != null);
      return result.user;
    } catch (e) {
      errorMessage = errorHandler.handleError(e);
      return null;
    }
  }

  onRegisterButtonPressed() {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();

      signUp(_emailId, _password).then((user) {
        if (user != null) {
          print('Registered successfully.');
          setState(() {
            successMessage =
                'Registered Successfully.\nYou can now navigate to Login Page';
          });
        } else {
          print('Error while register.');
        }
      });
    }
  }

  onLoginButtonPressed() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }
}
