//import 'package:afqyapp/models/event_attendee.dart';
//import 'package:afqyapp/screens/events/edit_interests.dart';
//import 'package:afqyapp/screens/events/profile_dialog.dart';
//import 'package:afqyapp/screens/events/verify_dialog.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:afqyapp/models/Eventbrite_event.dart';
//
//class TabWho extends StatefulWidget {
//  final EventbriteEvent event;
//  TabWho({Key key, @required this.event}) : super(key: key);
//
//  @override
//  _TabWhoState createState() => _TabWhoState();
//}
//
//class _TabWhoState extends State<TabWho> {
//  Future<List<EventAttendee>> _attendees;
//  String sortValue = 'A-Z';
//  List<EventAttendee> _searchResult = [];
//  TextEditingController _txtcontroller;
//  EventAttendee userAttendee;
//
//  @override
//  void initState() {
//    super.initState();
//    _txtcontroller = TextEditingController();
//    _attendees = widget.event.getAttendees();
//    _attendees.then((value){
//      _setPhotoURLs();
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
import 'package:afqyapp/models/attendee_model.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'attendee_widget.dart';

////      appBar: AppBar(
////        backgroundColor: Colors.white,
////        title: TextField(
////          controller: _txtcontroller,
////          decoration: InputDecoration(
////            labelText: 'Search',
////          ),
////          cursorColor: Colors.white,
////          style: TextStyle(color: Colors.white),
////        ),
////        leading: Icon(Icons.search),
////      ),
//      floatingActionButton: FloatingActionButton.extended(
//        backgroundColor: Colors.red[900],
//        icon: Icon(Icons.edit),
//        label: Text("Edit Interests"),
//        onPressed: () {
//          _editInterests(context);
//        },
//      ),
//      body: RefreshIndicator(
//          onRefresh: () {
//            setState(() {
//              _attendees = widget.event.refreshAttendees();
//              _attendees.then((value){
//                _setPhotoURLs();
//              });
//            });
//            return _attendees;
//          },
//          child: Container(
//            child: Column(
//              children: <Widget>[
//                Container(
//                        child: new Padding(
//                            padding: EdgeInsets.all(0.0),
//                            child: new Card(
//                                child: new ListTile(
//                                  leading: new Icon(Icons.search),
//                                  title: new TextField(
//                                    controller: _txtcontroller,
//                                    decoration: InputDecoration(
//                                        hintText: 'Enter name or interest', border: InputBorder.none
//                                    ),
//                                    onChanged: onSearchTextChanged, //method to control search action
//                                  ),
//                                  trailing: new IconButton(icon: new Icon(Icons.cancel),
//                                      onPressed: () {
//                                        _txtcontroller.clear();
//                                        onSearchTextChanged('');
//                                      }),
//                                )
//                            )
//                        ),
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text('Sort:',
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    SizedBox(width: 20.0),
//                    DropdownButton(
//                      value: sortValue,
//                      icon: Icon(Icons.filter_list),
//                      items: <String>['A-Z', 'Z-A', 'Common Interests']
//                          .map<DropdownMenuItem<String>>((String value) {
//                        return DropdownMenuItem<String>(
//                          value: value,
//                          child: Text(value),
//                        );
//                      }).toList(),
//                      onChanged: (value) {
//                        setState(() {
//                          sortValue = value;
//                          switch(value){
//                            case 'A-Z':
//                              widget.event.sortAttendeesAtoZ();
//                              break;
//                            case 'Z-A':
//                              widget.event.sortAttendeesZtoA();
//                              break;
//                            case 'Common Interests':
//                              widget.event.sortAttendeesByInterest(userAttendee);
//                          }
//                        });
//                      },
//                    ),
//                  ],
//                ),
//                Expanded(
//                  child: _searchResult.length != 0 || _txtcontroller.text.isNotEmpty ?
//                  new ListView.builder(
//                      itemCount: _searchResult.length,
//                      itemBuilder: (context, index) {
//                        return new Card(
//                          child: new ListTile(
//                              leading: CircleAvatar(
//                                backgroundColor: Colors.white,
//                                child: ClipOval(
//                                  child: FadeInImage.assetNetwork(
//                                    placeholder: 'assets/images/profile.png',
//                                    image: _searchResult[index].profileImage,
//                                    height: 50.0,
//                                    width: 50.0,
//                                    fit: BoxFit.cover,
//                                  ),
//                                ),
//                              ),
//                              title: Text(_searchResult[index].name),
//                              subtitle:
//                              Text(_searchResult[index].interests.join(", ")),
//                              trailing: FlatButton(
//                                child: _searchResult[index].saved
//                                    ? Icon(Icons.star)
//                                    : Icon(Icons.star_border),
//                                onPressed: () {
//                                  setState(() {
//                                    _searchResult[index].saved
//                                        ? widget.event
//                                        .removeConnection(_searchResult[index])
//                                        : widget.event
//                                        .addConnection(_searchResult[index]);
//                                  });
//                                },
//                              )
//                          ),
//                        );
//                      })
//                      : FutureBuilder(
//                    future: _attendees,
//                    builder: (context, snapshot) {
//                      if (snapshot.hasData) {
//                        //Load images in background
//                        List<EventAttendee> attendeeList = snapshot.data;
//                        return ListView.builder(
//                            itemCount: attendeeList.length,
//                            itemBuilder: (context, index) {
//                              if(attendeeList[index].current){
//                                userAttendee = attendeeList[index];
//                              }
//                              return Card(
//                                child: ListTile(
//                                    onTap: () {
//                                      _showProfileDialog(attendeeList[index]);
//                                    },
//                                  enabled: !attendeeList[index].current,
//                                    leading: CircleAvatar(
//                                      backgroundColor: Colors.white,
//                                      child: ClipOval(
//                                        child: FadeInImage.assetNetwork(
//                                          placeholder: 'assets/images/profile.png',
//                                          image: attendeeList[index].profileImage,
//                                          height: 50.0,
//                                          width: 50.0,
//                                          fit: BoxFit.cover,
//                                        ),
//                                      ),
//                                    ),
//                                    title: Text(attendeeList[index].name),
//                                    subtitle:
//                                    Text(attendeeList[index].interests.join(", ")),
//                                    trailing: FlatButton(
//                                      child: attendeeList[index].saved
//                                          ? Icon(Icons.star)
//                                          : Icon(Icons.star_border),
//                                      onPressed: attendeeList[index].current ? null : () {
//                                        setState(() {
//                                          attendeeList[index].saved
//                                              ? widget.event
//                                              .removeConnection(attendeeList[index])
//                                              : widget.event
//                                              .addConnection(attendeeList[index]);
//                                        });
//                                      },
//                                    )),
//                              );
//                            });
//                      } else if (snapshot.hasError) {
//                        return Center(child: Text(snapshot.error));
//                      } else {
//                        return Center(child: CircularProgressIndicator());
//                      }
//                    },
//                  ),
//                )
//              ],
//            ),
//          )
//      ),
//    );
//  }
//
//  onSearchTextChanged(String text) async {
//    _searchResult.clear();
//    if(text.isEmpty){
//      setState(() {});
//      return;
//    }
//    List<EventAttendee> attendees = await _attendees;
//    attendees.forEach((attendee) {
//      bool isAlreadyAdded = false;
//      if(attendee.name.toLowerCase().contains(text.toLowerCase())) {
//        _searchResult.add(attendee);
//        isAlreadyAdded = true;
//      }
//      if(!isAlreadyAdded && attendee.interests.length != 0){
//        attendee.interests.forEach((interest) {
//          if(!isAlreadyAdded && interest.toLowerCase().contains(text.toLowerCase())){
//            _searchResult.add(attendee);
//            isAlreadyAdded = true;
//          }
//        });
//      }
//    });
//    setState(() {});
//  }
//
//  Future _editInterests(context) async {
//    //Check if user is verified
//    await widget.event.checkTicket().then((verified) {
//      if (verified) {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => EditInterestsScreen(event: widget.event),
//            )).then((value) => setState(() {}));
//      } else {
//        _showVerifyDialog();
//      }
//    }).catchError((error) {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
//    });
//  }
//
//  Future<void> _showVerifyDialog() async {
//    return showDialog<void>(
//      context: context,
//      builder: (BuildContext context) {
//        return VerifyDialog(event: widget.event);
//      },
//    );
//  }
//
//  void _setPhotoURLs() async{
//    await widget.event.setProfileURLs();
//    setState(() {
//
//    });
//  }
//
//  Future<void> _showProfileDialog(EventAttendee attendee) async {
//    return showDialog<void>(
//      context: context,
//      builder: (BuildContext context){
//        return ProfileDialog(attendee: attendee);
//      },
//    );
//  }
//}

class TabWho extends StatefulWidget {
  final EventModel event;

  TabWho({Key key, @required this.event}) : super(key: key);

  @override
  _TabWhoState createState() => _TabWhoState();
}

class _TabWhoState extends State<TabWho> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.event.streamCallback = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<AttendeeModel> _attendees = widget.event.attendees;

    return ListView.builder(
      itemCount: _attendees.length,
      itemBuilder: (context, index){
        return AttendeeWidget(_attendees[index]);
      },
    );
  }
}

