import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/attendee_widget.dart';
import 'package:afqyapp/screens/events/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:afqyapp/models/Eventbrite_event.dart';

class TabConnections extends StatefulWidget {
  final EventModel event;
  TabConnections({Key key, @required this.event}) : super(key: key);

  @override
  _TabConnectionsState createState() => _TabConnectionsState();
}

class _TabConnectionsState extends State<TabConnections> {
  List<AttendeeModel> _attendees;

  @override
  Widget build(BuildContext context) {
    widget.event.streamCallback = () => setState(() {});
    _attendees = widget.event.attendees.where((element) => element.isConnection).toList();
    
    return ListView.builder(
      itemCount: _attendees.length,
      itemBuilder: (context, index){
        return AttendeeWidget(_attendees[index], widget.event);
      },
    );
  }
}