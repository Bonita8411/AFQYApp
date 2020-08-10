import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/screens/events/edit_interests.dart';
import 'package:afqyapp/screens/events/profile_dialog.dart';
import 'package:afqyapp/screens/events/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:afqyapp/models/Eventbrite_event.dart';

class TabWho extends StatefulWidget {
  final EventbriteEvent event;
  TabWho({Key key, @required this.event}) : super(key: key);

  @override
  _TabWhoState createState() => _TabWhoState();
}

class _TabWhoState extends State<TabWho> {
  Future<List<EventAttendee>> _attendees;

  @override
  void initState() {
    super.initState();
    _attendees = widget.event.getAttendees();
    _attendees.then((value){
      _setPhotoURLs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[900],
        icon: Icon(Icons.edit),
        label: Text("Edit Interests"),
        onPressed: () {
          _editInterests(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _attendees = widget.event.refreshAttendees();
            _attendees.then((value){
              _setPhotoURLs();
            });
          });
          return _attendees;
        },
        child: FutureBuilder(
          future: _attendees,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //Load images in background
              List<EventAttendee> attendeeList = snapshot.data;
              return ListView.builder(
                  itemCount: attendeeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          _showProfileDialog(attendeeList[index]);
                        },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/profile.png',
                                  image: attendeeList[index].profileImage,
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(attendeeList[index].name),
                          subtitle:
                              Text(attendeeList[index].interests.join(", ")),
                          trailing: FlatButton(
                            child: attendeeList[index].saved
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border),
                            onPressed: () {
                              setState(() {
                                attendeeList[index].saved
                                    ? widget.event
                                        .removeConnection(attendeeList[index])
                                    : widget.event
                                        .addConnection(attendeeList[index]);
                              });
                            },
                          )),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future _editInterests(context) async {
    //Check if user is verified
    await widget.event.checkTicket().then((verified) {
      if (verified) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditInterestsScreen(event: widget.event),
            ));
      } else {
        _showVerifyDialog();
      }
    }).catchError((error) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
    });
  }

  Future<void> _showVerifyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return VerifyDialog(event: widget.event);
      },
    );
  }

  void _setPhotoURLs() async{
    await widget.event.setProfileURLs();
    setState(() {

    });
  }

  Future<void> _showProfileDialog(EventAttendee attendee) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return ProfileDialog(attendee: attendee);
      },
    );
  }
}
