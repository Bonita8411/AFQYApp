import 'package:afqyapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AFQY App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Home Screen; You are logged in"),
            RaisedButton(
              child: Text("Logout"),
              onPressed: () {
                AuthService.signOut().catchError((error) {
                  print(error);
                });
              },
            )
          ]
        ),
      ),
    );
  }
}
