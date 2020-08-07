import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/screens/events/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:afqyapp/models/Eventbrite_event.dart';

class TabConnections extends StatefulWidget {
  final EventbriteEvent event;
  TabConnections({Key key, @required this.event}) : super(key: key);

  @override
  _TabConnectionsState createState() => _TabConnectionsState();
}

class _TabConnectionsState extends State<TabConnections> {
  Future<List<EventAttendee>> _attendees;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attendees = widget.event.getAttendees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _attendees = widget.event.refreshAttendees();
          });
          return _attendees;
        },
        child: FutureBuilder(
          future: _attendees,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventAttendee> connectionList = snapshot.data;
              return ListView.builder(
                  itemCount: connectionList.length,
                  itemBuilder: (context, index) {
                    if(connectionList[index].saved == true){
                      return Card(
                        child: ListTile(
                            onTap: () {
                              _showProfileDialog(connectionList[index]);
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/profile.png',
                                  image: connectionList[index].profileImage,
                                  height: 50.0,
                                  width: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(connectionList[index].name),
                            subtitle:
                            Text(connectionList[index].interests.join(", ")),
                            trailing: FlatButton(
                              child: Icon(Icons.star),
                              onPressed: () {
                                setState(() {
                                  widget.event.removeConnection(connectionList[index]);
                                });
                              },
                            )
                        ),
                      );
                    }
                    return Container();
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

  Future<void> _showProfileDialog(EventAttendee attendee) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return ProfileDialog(attendee: attendee);
      },
    );
  }
}