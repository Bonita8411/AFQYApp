
import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'EventDetail.dart';

class Event extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventState();
  }
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<List<EventbriteEvent>>(
      future: EventbriteService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data;
          return ListView.builder(
              itemCount: events == null ? 0 : events.length,
              itemBuilder: (BuildContext context, int index) {
                final event = events[index];
                String startMon, startDay, startTime, endTime;
                startMon = DateFormat('MMM').format(event.startDT);
                startDay = DateFormat('d').format(event.startDT);
                startTime = (!event.hideStartTime)
                    ? DateFormat('jm').format(event.startDT)
                    : "TBA";
                endTime = (!event.hideEndTime)
                    ? DateFormat('jm').format(event.endDT)
                    : "TBA";
                return Card(
                  child: Row(
                    children: <Widget>[
                      new Flexible(
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetail(event: events[index]),
                                    ));
                              },
                              leading: CircleAvatar(
                                  backgroundColor: Colors.red[900],
                                  radius: 36.0,
                                  foregroundColor: Colors.grey[100],
                                  child: Text(startDay + "\n" + startMon,
                                      textAlign: TextAlign.center)),
                              title: Text(event.title),
                              subtitle: Text(event.location +
                                  "\n" +
                                  startTime +
                                  " - " +
                                  endTime +
                                  " NZST"),
                              isThreeLine: true))
                    ],
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    ));
  }
}
