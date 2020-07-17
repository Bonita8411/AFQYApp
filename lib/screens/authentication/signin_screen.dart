import 'package:afqyapp/screens/authentication/forgot_password_screen.dart';
import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";
import 'package:validators/validators.dart';

class SignInScreen extends StatefulWidget {
  final Function toggleSignIn;

  SignInScreen({this.toggleSignIn});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  bool _loading = false;
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (val) {
                      if (!isEmail(val)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _email = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Please supply a password";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      _error,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text("Sign in"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => _loading = true);
                        AuthService.signInWithEmailAndPassword(_email, _password).catchError((error){
                          setState(() => _loading = false);
                          _error = error;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    child: Text("Not a member? Register"),
                    onPressed: widget.toggleSignIn,
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    child: Text("Forgot Password?"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordScreen(),
                          ));
                    },
                  ),
                  SizedBox(height: 100.0),
                  //The anonymous Sign in is for testing only, remove in release versions
                ],
              ),
            ),
          ),
          _loading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }
}
