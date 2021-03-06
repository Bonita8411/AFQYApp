import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/profile_dialog.dart';
import 'package:flutter/material.dart';

class AttendeeWidget extends StatefulWidget {
  final AttendeeModel attendee;
  final EventModel event;

  AttendeeWidget(this.attendee, this.event);

  @override
  _AttendeeWidgetState createState() => _AttendeeWidgetState();
}

class _AttendeeWidgetState extends State<AttendeeWidget> {
  @override
  Widget build(BuildContext context) {
    AttendeeModel attendee = widget.attendee;
    return Card(
      child: ListTile(
        enabled: !attendee.isCurrentUser,
        leading: CircleAvatar(
          backgroundColor: Colors.red[900],
          child: ClipOval(
            child: attendee.profilePictureURL != null ?
            FadeInImage.assetNetwork(
              image: attendee.profilePictureURL,
              placeholder: 'assets/images/profile.png',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            )
            : Image.asset('assets/images/profile.png',
              width: 50.0,
              height: 50.0,
            ),
          ),
        ),
        title: Text(attendee.name),
        subtitle: Text(attendee.interests.join(', ')),
        trailing: IconButton(
          icon: attendee.isConnection ?
            Icon(Icons.star) :
            Icon(Icons.star_border),
            onPressed: attendee.isCurrentUser ? null : () {
            if(widget.event.currentAttendee != null){
              if(attendee.isConnection){
                widget.event.removeConnection(attendee.attendeeID);
              }else{
                widget.event.addConnection(attendee.attendeeID);
              }
            }else{
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('You must have a verified ticket to add connections.'),
              ));
            }
            },
        ),
        onTap: () {
          return showDialog<void>(
            context: context,
            builder: (BuildContext context){
              return ProfileDialog(attendee: attendee, purchasedTicket: widget.event.currentAttendee != null,);
            },
          );

        },
      ),
    );
  }
}


