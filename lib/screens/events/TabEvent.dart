import 'package:afqyapp/models/Eventbrite_event.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:url_launcher/url_launcher.dart";

class TabEvent extends StatelessWidget {
  final EventbriteEvent event;
//  final String _text;

  TabEvent({Key key, @required this.event}) : super(key: key);

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
    String startTime, endTime;
    startTime = DateFormat('yMd').add_jm().format(event.startDT);
    endTime = DateFormat('yMd').add_jm().format(event.endDT);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              // Picture of event

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      "DESCRIPTION",
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 40.0,
                    height: 35.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: RaisedButton(
                        color: Colors.red[900],
                        onPressed: () {
                          _launchURL(event.url);
                        },
                        child: Text(
                            "Purchase Ticket",
                          style: TextStyle(
                            color: Colors.grey[100]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                event.description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "LOCATION",
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                ),
              ),
              Text(
                event.location,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "TIME/DATE",
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                ),
              ),
              Text(
                startTime + " - " + endTime,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "URL",
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                ),
              ),
              Container(
                child: Text(
                  event.url,
                  style: TextStyle(
                      color: Colors.grey[600]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}