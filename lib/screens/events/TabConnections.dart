import 'package:flutter/material.dart';
import 'package:afqyapp/models/Eventbrite_event.dart';

class TabConnections extends StatefulWidget {
  final EventbriteEvent event;
  TabConnections({Key key, @required this.event}) : super(key: key);

  @override
  _TabConnectionsState createState() => _TabConnectionsState();
}

class _TabConnectionsState extends State<TabConnections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Refresh"),
          onPressed: () {
            widget.event.refreshConnections();
          },
        )
      ),
    );
  }
}