import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/screens/events/TabConnections.dart';
import 'package:afqyapp/screens/events/TabWho.dart';
import "package:flutter/material.dart";

import 'TabEvent.dart';

class EventDetail extends StatelessWidget {
  final EventbriteEvent event;

  EventDetail({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child:Scaffold(
            appBar: AppBar(
                title: Text(event.title),
                backgroundColor: Colors.red[900],
                bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Event',
                      ),
                      Tab(
                        text: 'Who\'s Going',
                      ),
                      Tab(
                        text: 'Connections',
                      )
                    ]
                )
            ),
            body: TabBarView(
              children: <Widget>[
                TabEvent(event: event, key: key,),
                TabWho(event: event, key: key,),
                TabConnections(event: event, key: key),
              ],
            )
        )
    );
  }
}