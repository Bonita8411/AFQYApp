import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/screens/events/TabConnections.dart';
import 'package:afqyapp/screens/events/TabWho.dart';
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import 'TabEvent.dart';

class EventDetail extends StatelessWidget {
  final EventbriteEvent event;
//  final String _text;

  EventDetail({Key key, @required this.event}) : super(key: key);

  _launchURL(String url) async {
    final _url = event.url;
    if (await canLaunch(_url)) {
      await launch(_url);
    } else{
      throw 'Could not launch $_url';
    }
  }

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