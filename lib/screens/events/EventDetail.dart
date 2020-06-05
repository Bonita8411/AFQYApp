import 'package:afqyapp/models/Eventbrite_event.dart';
import "package:flutter/material.dart";
import 'package:afqyapp/screens/TabConnections.dart';
import 'package:afqyapp/screens/TabEvent.dart';
import 'package:afqyapp/screens/TabWho.dart';

class EventDetail extends StatelessWidget {
  final EventbriteEvent event;
//  final String _text;
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
                TabConnections(),
              ],
            )
        )
    );
  }
}