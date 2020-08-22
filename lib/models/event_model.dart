import 'package:cloud_firestore/cloud_firestore.dart';

import 'attendee_model.dart';

class EventModel{
  String eventID;
  String name;
  String shortDescription;
  String htmlDescription;
  String photoURL;
  DateTime startTime;
  DateTime endTime;
  List<AttendeeModel> attendees = [];

  EventModel(this.eventID, this.name, this.shortDescription,
      this.htmlDescription, this.photoURL, this.startTime, this.endTime);

  EventModel.fromFirestoreSnapshot(DocumentSnapshot snapshot) :
        this.eventID = snapshot.documentID,
        this.name = snapshot.data['name'],
        this.shortDescription = snapshot.data['shortDescription'],
        this.htmlDescription = snapshot.data['htmlDescription'],
        this.photoURL = snapshot.data['photoURL'],
        this.startTime = snapshot.data['startTime'],
        this.endTime = snapshot.data['endTime'];

  void addAttendeeStreamListener(Function callback){
    Firestore.instance.collection('events/' + eventID + '/attendees').snapshots().listen((snapshot) {
      int started = 0;
      int completed = 0;
      snapshot.documentChanges.forEach((attendeeSnapshot) {
        AttendeeModel a = AttendeeModel.fromFirebaseSnapshot(attendeeSnapshot.document);
        int foundAt = attendees.indexWhere((searchAttendee) => searchAttendee.attendeeID == attendeeSnapshot.document.documentID);
        if(foundAt == -1){
          attendees.add(a);
        }else{
          if(attendeeSnapshot.type == DocumentChangeType.removed){
            attendees.removeAt(foundAt);
          }else{
            attendees[foundAt] = a;
            started++;
            a.refreshLinkedProfile().then((value) {
              completed++;
              if(started == completed){
                callback();
              }
            });
          }
        }
      });
    });
  }
}