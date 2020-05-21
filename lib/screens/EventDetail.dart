import 'package:afqyapp/screens/Eventbrite_event.dart';
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
          child: ListView(
            children: <Widget>[
              Text(event.description),
              Container(
                child: Text(event.url),
              ),
              RaisedButton(
                child: Text("Purchase Ticket"),
                onPressed: () {
                  _launchURL(event.url);
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}