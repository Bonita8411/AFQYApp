import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/home_screen/0.jpg',
        ),
      ),
    )));
  }
}
