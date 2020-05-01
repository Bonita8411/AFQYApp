import 'package:afqyapp/screens/authentication/register_screen.dart';
import 'package:afqyapp/screens/authentication/signin_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return _showSignIn ? SignInScreen(toggleSignIn: toggleSignIn) : RegisterScreen(toggleSignIn: toggleSignIn);
  }

  void toggleSignIn(){
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }
}
