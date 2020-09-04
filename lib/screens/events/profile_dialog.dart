import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/screens/chat/thread_screen.dart';
import 'package:afqyapp/services/message_service.dart';
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
                      child: attendee.profilePictureURL != null ? FadeInImage.assetNetwork(
                          placeholder: 'assets/images/profile.png',
                          image: attendee.profilePictureURL)
                          : Image.asset('assets/images/profile.png',
                      fit: BoxFit.cover),
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
              Text(attendee.bio != null ? attendee.bio : '',
                textAlign: TextAlign.center,
                ),
              SizedBox(height: 10.0),
              Text("Interests: " + attendee.interests.join(", "),
                textAlign: TextAlign.center,
              ),
              attendee.uid == null ? Container()
                  : RaisedButton(
                      child: Text('Send Message'),
                      onPressed: (){
                        MessageService.instance.newThread([attendee.uid]).then((thread) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ThreadScreen(thread)));
                        });
                    },
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
