import 'package:afqyapp/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  List<EventModel> events;
  Function streamCallback;
  String eventCollection = 'events-testing';

  EventService._privateConstructor() {
    events = [];
    Firestore.instance.collection(eventCollection).where("status", isEqualTo: "live").snapshots().listen((snapshot) => _onSnapshot(snapshot));
  }

  static final EventService _instance = EventService._privateConstructor();

  static EventService get instance => _instance;

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