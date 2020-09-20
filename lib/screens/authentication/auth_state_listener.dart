import 'package:afqyapp/screens/authentication/auth_screen.dart';
import 'package:afqyapp/screens/home_screen.dart';
import 'package:afqyapp/services/message_service.dart';
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthStateListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
//          AuthService.currentUser = user;
          if (user == null) {
            return AuthScreen();
          }
          MessageService.instance.setCurrentUser();
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
