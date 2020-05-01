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
            Text("Home Screen"),
            SizedBox(height: 10.0),
            Text("Welcome: " + (AuthService.currentUser.displayName != null ? AuthService.currentUser.displayName : "Anon User")),
            SizedBox(height: 10.0),
            Text("User ID: " + AuthService.currentUser.uid),
            SizedBox(height: 10.0),
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
