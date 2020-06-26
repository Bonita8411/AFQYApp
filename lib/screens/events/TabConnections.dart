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
  Future<List<EventAttendee>> _connections;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connections = widget.event.refreshConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _connections = widget.event.refreshConnections();
          });
        },
        child: FutureBuilder(
          future: _connections,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasData) {
              List<EventAttendee> connectionList = snapshot.data;
              return ListView.builder(
                  itemCount: connectionList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          size: 56.0,
                        ),
                        title: Text(connectionList[index].name),
                        subtitle:
                        Text(connectionList[index].interests.join(", ")),
                        trailing: connectionList[index].saved
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                      ),
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
}