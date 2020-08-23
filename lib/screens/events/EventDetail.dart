import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/TabConnections.dart';
import 'package:afqyapp/screens/events/TabWho.dart';
import "package:flutter/material.dart";
import 'TabEvent.dart';

class EventDetail extends StatefulWidget{
  final EventModel event;
  EventDetail({Key key, @required this.event}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> with SingleTickerProviderStateMixin {
  final List<Tabs> _tabs = [
    new Tabs(title: "Event"),
    new Tabs(title: "Who\'s Going"),
    new Tabs(title: "Favourites")];
  TabController _tcontroller;
  String currentTitle;

  @override
  void initState() {
    super.initState();
    currentTitle = _tabs[0].title;
    _tcontroller = TabController(vsync: this, length: _tabs.length);
    _tcontroller.addListener(changeTitle); // Registering listener
    widget.event.startLoadingAttendees();
  }

  void changeTitle() {
    setState(() {
      // get index of active tab & change current appbar title
      currentTitle = _tabs[_tcontroller.index].title;

    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:Scaffold(
        appBar: AppBar(
          title: Text(widget.event.name),
          backgroundColor: Colors.red[900],
          bottom: TabBar(
            tabs: <Widget>[
              new Tab(text: _tabs[0].title),
              new Tab(text: _tabs[1].title),
              new Tab(text: _tabs[2].title),
            ],
            onTap: (index){
            },
          ),
//                actions: <Widget>[
//                  IconButton(
//                    icon: new Icon(
//                      Icons.search,
//                      color: this._tabs[_tcontroller.index].color,
//                    ),
//                  ),
//                ],
        ),
        body: TabBarView(
          children: <Widget>[
            TabEvent(event: widget.event, key: widget.key,),
            TabWho(event: widget.event, key: widget.key,),
            TabConnections(event: widget.event, key: widget.key,),
          ],
        ),
      ),
    );
  }
}

class Tabs {
  final String title;
  Tabs({this.title});
}