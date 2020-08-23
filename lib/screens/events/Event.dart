import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/services/event_service.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:afqyapp/screens/events/EventDetail.dart';

class Event extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventState();
  }
}

class _EventState extends State<Event> {
  List<EventModel> _eventList;

  @override
  void initState() {
    super.initState();
    _eventList = EventService.instance.events;
    EventService.instance.streamCallback = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                  itemCount: _eventList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = _eventList[index];
                    String startMon, startDay, startTime, endTime;
                    startMon = DateFormat('MMM').format(event.startTime);
                    startDay = DateFormat('d').format(event.startTime);
                    startTime = (event.startTime != null)
                        ? DateFormat('jm').format(event.startTime)
                        : "TBA";
                    endTime = (event.endTime != null)
                        ? DateFormat('jm').format(event.endTime)
                        : "TBA";
                    return Card(
                      child: Row(
                        children: <Widget>[
                          new Flexible(
                              child: ListTile(
                                  onTap: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) =>
//                                              EventDetail(event: _eventList[index]),
//                                        ));
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.red[900],
                                      radius: 36.0,
                                      foregroundColor: Colors.grey[100],
                                      child: Text(startDay + "\n" + startMon,
                                          textAlign: TextAlign.center)),
                                  title: Text(event.name),
                                  subtitle: Text(event.location != null ? event.location : 'TBA' +
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
  }
}