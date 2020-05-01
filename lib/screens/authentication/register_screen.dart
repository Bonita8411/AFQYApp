import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleSignIn;

  RegisterScreen({this.toggleSignIn});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _confirmPassword;

  bool _loading = false;
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Full Name",
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Please supply a name";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _name = val;
                      });
                    },
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
                      } else if (_password != _confirmPassword) {
                        return "Passwords don't match";
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        _confirmPassword = val;
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
                    child: Text("Register"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => _loading = true);
                        AuthService.registerWithEmailAndPassword(_name, _email, _password).catchError((error){
                          setState(() => _loading = false);
                          _error = error;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    child: Text("Already registered? Sign in"),
                    onPressed: widget.toggleSignIn,
                  ),
                ],
              ),
            ),
          ),
        ),
        _loading ? Center(child: CircularProgressIndicator()) : Container(),
      ],
    );
  }
}
