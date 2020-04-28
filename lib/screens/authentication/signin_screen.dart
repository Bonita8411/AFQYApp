import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RaisedButton(
              child: Text("Sign in Anonymously"),
              onPressed: () {
                AuthService.signInAnon().catchError((error) {
                  print(error);
                });
              },
            ),
        ),
    );
  }
}
