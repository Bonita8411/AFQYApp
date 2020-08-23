import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/screens/events/edit_interests.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatefulWidget {
  final AttendeeModel attendee;
  ProfileDialog({Key key, @required this.attendee}) : super(key: key);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    AttendeeModel attendee = widget.attendee;

    return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.red[900],
                child: ClipOval(
                  child: new SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/profile.png',
                          image: attendee.profilePictureURL)
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                attendee.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              SizedBox(height: 10.0),
              Text(attendee.interests.join(", "),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
