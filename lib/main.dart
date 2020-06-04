import 'dart:convert';
import 'package:afqyapp/screens/authentication/auth_state_listener.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthStateListener(),
    );
  }
}