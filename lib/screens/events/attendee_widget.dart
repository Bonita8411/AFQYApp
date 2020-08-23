import 'package:afqyapp/models/attendee_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AttendeeWidget extends StatefulWidget {
  final AttendeeModel attendee;

  AttendeeWidget(this.attendee);

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
        leading: attendee.profilePictureURL != null ?
        CircleAvatar(
          backgroundColor: Colors.red[900],
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: attendee.profilePictureURL,
              placeholder: (context, url) => Image.asset('assets/images/profile.png'),
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
        )
            : Image.asset('assets/images/profile.png'),
        title: Text(attendee.name),
        subtitle: Text(attendee.interests.join(', ')),
      ),
    );
  }
}


