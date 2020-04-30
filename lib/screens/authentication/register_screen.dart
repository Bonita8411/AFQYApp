import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text("Register",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
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
                onChanged: (val) {
                  setState(() {
                    _email = val;
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
              RaisedButton(
                child: Text("Register"),
                onPressed: () async {
                  //call register with email and password from AuthService
                },
              ),
              SizedBox(height: 20.0),
              FlatButton(
                child: Text("Already registered? Sign in"),
                onPressed: widget.toggleSignIn,
              ),
              //The anonymous Sign in is for testing only, remove in release versions
//                RaisedButton(
//                  child: Text("Sign in Anonymously"),
//                  onPressed: () {
//                    AuthService.signInAnon().catchError((error) {
//                      print(error);
//                    });
//                  },
//                ),
            ],
          ),
        ),
      ),
    );
  }
}
