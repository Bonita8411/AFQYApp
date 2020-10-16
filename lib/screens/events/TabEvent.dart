import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/verify_instruction.dart';
import 'package:afqyapp/screens/web_browser.dart';
import "package:flutter/material.dart";
import 'package:afqyapp/screens/events/verify_instruction.dart';
import 'package:intl/intl.dart';

class TabEvent extends StatefulWidget {
  final EventModel event;

  TabEvent({Key key, @required this.event}) : super(key: key);

  @override
  _TabEventState createState() => _TabEventState();
}

class _TabEventState extends State<TabEvent> {
  @override
  Widget build(BuildContext context) {
    String startTime, endTime;
    startTime = DateFormat('yMd').add_jm().format(widget.event.startTime);
    endTime = DateFormat('yMd').add_jm().format(widget.event.endTime);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              // Picture of event
              widget.event.photoURL != null ? Image.network(widget.event.photoURL) : Container(),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WebBrowser("https://www.eventbrite.co.nz/checkout-external?eid=" + widget.event.eventID),
                              )
                          ).then((value) => _showVerifyInstruction());
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
                widget.event.shortDescription,
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
                widget.event.location,
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
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _showVerifyInstruction() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return VerifyInstruction();
      },
    );
  }
}



