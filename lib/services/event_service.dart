import 'dart:async';

import 'package:afqyapp/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  List<EventModel> events;
  Function streamCallback;
  String eventCollection = 'events-testing';
  // String eventCollection = 'events-production';
  StreamSubscription streamSubscription;


  EventService._privateConstructor() {
    refreshEvents();
    print('Event Service Started');
  }

  static final EventService _instance = EventService._privateConstructor();

  static EventService get instance => _instance;

  void refreshEvents(){
    if(streamSubscription != null){
      streamSubscription.cancel();
    }
    events = [];
    streamSubscription = Firestore.instance.collection(eventCollection).where("status", whereIn: ["live", "started", "ended", "completed"]).snapshots().listen((snapshot) => _onSnapshot(snapshot));
  }

  void _onSnapshot(QuerySnapshot snapshot){
    snapshot.documentChanges.forEach((event) {
      int foundAt = events.indexWhere((element) => element.eventID == event.document.documentID);
      if(foundAt == -1){
        events.add(EventModel.fromFirestoreSnapshot(event.document));
      } else if(event.type == DocumentChangeType.removed){
        events.removeAt(foundAt);
      }
    });
    if(streamCallback != null){
      streamCallback();
    }
  }
}