import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:flutter/material.dart';

class EditInterestsScreen extends StatefulWidget {
  final EventbriteEvent event;
  EditInterestsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Interests"),
        backgroundColor: Colors.red[900],
      ),
      body: Center(child: Text("edit interests"),),
    );
  }
}
