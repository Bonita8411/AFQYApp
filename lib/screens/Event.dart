import 'package:afqyapp/screens/Eventbrite_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'EventDetail.dart';

class Event extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventState();
  }
}

class _EventState extends State<Event> {
  Future<List<EventbriteEvent>> futureEvents;

  Future<List<EventbriteEvent>> getData() async {
    http.Response response = await http.get('https://www.eventbriteapi.com/v3/organizations/444403409470/events/?token=PKK2ODAKPV7VZ7TOLK6R&expand=venue');

    if (response.statusCode == 200) {
      List<EventbriteEvent> eventList = new List<EventbriteEvent>();
      final jsonResponse = json.decode(response.body)["events"];
      String title, description, location, url;
      DateTime startDT, endDT;
      bool hideStartTime, hideEndTime;
      for (int i = 0; i < jsonResponse.length; i++) {
        final event = jsonResponse[i];
        // Add if an event is available / not cancelled or drafted
        if(event["status"]=="live") {
          title = event["name"]["text"];
          description = event["description"]["text"];
          startDT = DateTime.parse(event["start"]["local"]);
          endDT = DateTime.parse(event["end"]["local"]);
          hideStartTime = event["hide_start_date"];
          hideEndTime = event["hide_end_date"];
          url = event["url"];
          if (event["online_event"] == true) {
            location = "Online Event";
          }
          else if (event["venue"] == null) {
            location = "TBA";
          }
          else {
            location = event["venue"]["name"];
          }
          eventList.add(new EventbriteEvent(
              title: title, description: description, location: location, startDT: startDT, endDT: endDT, url: url, hideStartTime: hideStartTime, hideEndTime: hideEndTime));
        }
      }
      return eventList;
    } else{
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureEvents = getData();
  }

  @override
    Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<EventbriteEvent>>(
        future: futureEvents,
        builder: (context, snapshot){
          if(snapshot.hasData){
            final events = snapshot.data;
            if(events.length>0) {
              return ListView.builder(
                  itemCount: events == null ? 0 : events.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = events[index];
                    String startMon, startDay, startTime, endTime;
                    startMon = DateFormat('MMM').format(event.startDT);
                    startDay = DateFormat('d').format(event.startDT);
                    startTime = (!event.hideStartTime) ? DateFormat('jm')
                        .format(event.startDT)
                        : "TBA";
                    endTime = (!event.hideEndTime) ? DateFormat('jm')
                        .format(event.endDT)
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
                                        )
                                    );
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.red[900],
                                      radius: 36.0,
                                      foregroundColor: Colors.grey[100],
                                      child: Text(startDay + "\n" + startMon,
                                          textAlign: TextAlign.center)
                                  ),
                                  title: Text(event.title),
                                  subtitle: Text(
                                      event.location + "\n" + startTime +
                                          " - " + endTime + " NZST"),
                                  isThreeLine: true
                              ))
                        ],
                      ),
                    );
                  }
              );
            } else{
              return Text("NO EVENT AVAILABLE");
            }
          }else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}