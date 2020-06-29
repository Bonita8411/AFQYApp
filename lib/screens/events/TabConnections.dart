import 'package:afqyapp/models/event_attendee.dart';
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
        onRefresh: () async {
          setState(() {
            _attendees = widget.event.refreshAttendees();
          });
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
                              setState(() {
                                widget.event.removeConnection(connectionList[index]);
                              });
                            },
                            leading: Icon(
                              Icons.account_circle,
                              size: 56.0,
                            ),
                            title: Text(connectionList[index].name),
                            subtitle:
                            Text(connectionList[index].interests.join(", ")),
                            trailing: Icon(Icons.star)
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
}