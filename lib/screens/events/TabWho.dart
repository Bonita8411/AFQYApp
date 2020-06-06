import 'package:afqyapp/models/event_attendee.dart';
import 'package:flutter/material.dart';
import 'package:afqyapp/models/Eventbrite_event.dart';
import "package:url_launcher/url_launcher.dart";

class TabWho extends StatefulWidget {
  final EventbriteEvent event;
  TabWho({Key key, @required this.event}) : super(key: key);

  @override
  _TabWhoState createState() => _TabWhoState();
}

class _TabWhoState extends State<TabWho> {
  Future<List<EventAttendee>> _attendees;

  @override
  void initState() {
    super.initState();
    _attendees = widget.event.getAttendees();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _attendees = widget.event.refreshAttendees();
        });
      },
      child: FutureBuilder(
        future: _attendees,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<EventAttendee> attendeeList = snapshot.data;
            return ListView.builder(
              itemCount: attendeeList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(attendeeList[index].name),
                  ),
                );
              }
            );
          }else if(snapshot.hasError){
            return Center(child: Text(snapshot.error));
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}