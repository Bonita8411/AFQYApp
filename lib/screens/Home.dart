import 'dart:math';

import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";

class Home extends StatelessWidget {
  static var pictures = [
    "assets/images/home_screen/00.jpg",
    "assets/images/home_screen/01.jpg",
    "assets/images/home_screen/02.jpg",
    "assets/images/home_screen/03.jpg",
    "assets/images/home_screen/04.jpg",
    "assets/images/home_screen/05.jpg",
    "assets/images/home_screen/06.jpg"
  ];
  Random rnd;
  @override
  Widget build(BuildContext context) {
    rnd = new Random();
    int r = 0 + rnd.nextInt((pictures.length - 1) - 0);
    String imgString = pictures[r].toString();

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imgString,
        ),
      ),
    )));
  }
}
