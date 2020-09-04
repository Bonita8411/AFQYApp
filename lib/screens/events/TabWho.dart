import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'attendee_widget.dart';
import 'edit_interests.dart';

class TabWho extends StatefulWidget {
  final EventModel event;

  TabWho({Key key, @required this.event}) : super(key: key);

  @override
  _TabWhoState createState() => _TabWhoState();
}

class _TabWhoState extends State<TabWho> {
  List<AttendeeModel> _searchResult = [];
  TextEditingController _txtcontroller;
  String sortValue = 'A-Z';

  @override
  void initState() {
    _txtcontroller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.event.streamCallback = () => setState(() {});
    List<AttendeeModel> _attendees = _searchResult.length != 0 || _txtcontroller.text.isNotEmpty ? _searchResult : widget.event.attendees;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[900],
        icon: Icon(Icons.edit),
        label: widget.event.currentAttendee != null ? Text("Edit Interests") : Text('Verify Ticket'),
        onPressed: () {
          _editInterests(context);
        },
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(0.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: _txtcontroller,
                    decoration: InputDecoration(
                        hintText: 'Enter name or interest', border: InputBorder.none
                    ),
                    onChanged: onSearchTextChanged, //method to control search action
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel),
                    onPressed: () {
                      _txtcontroller.clear();
                      onSearchTextChanged('');
                    }),
                )
                )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Sort:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20.0),
              DropdownButton(
                value: sortValue,
                icon: Icon(Icons.filter_list),
                items: <String>['A-Z', 'Z-A', 'Common Interests']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sortValue = value;
                    switch(value){
                      case 'A-Z':
                        widget.event.sortAttendeesAtoZ();
                        break;
                      case 'Z-A':
                        widget.event.sortAttendeesZtoA();
                        break;
                      case 'Common Interests':
                        widget.event.sortAttendeesByInterest();
                    }
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _attendees.length,
              itemBuilder: (context, index){
                return AttendeeWidget(_attendees[index], widget.event);
              },
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }
    List<AttendeeModel> attendees = widget.event.attendees;
    attendees.forEach((attendee) {
      bool isAlreadyAdded = false;
      if(attendee.name.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(attendee);
        isAlreadyAdded = true;
      }
      if(!isAlreadyAdded && attendee.interests.length != 0){
        attendee.interests.forEach((interest) {
          if(!isAlreadyAdded && interest.toLowerCase().contains(text.toLowerCase())){
            _searchResult.add(attendee);
            isAlreadyAdded = true;
          }
        });
      }
    });
    setState(() {});
  }

  Future _editInterests(context) async {
    //Check if user is verified
    await widget.event.isCurrentUserVerified().then((verified) {
      if (verified) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditInterestsScreen(event: widget.event),
            )).then((value) => setState(() {}));
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
}

