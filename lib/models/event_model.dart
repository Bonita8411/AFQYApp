import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'attendee_model.dart';

class EventModel {
  String eventID;
  String name;
  String shortDescription;
  String htmlDescription;
  String photoURL;
  DateTime startTime;
  DateTime endTime;
  List<AttendeeModel> attendees = [];
  Function streamCallback;

  EventModel.fromFirestoreSnapshot(DocumentSnapshot snapshot) :
        this.eventID = snapshot.documentID,
        this.name = snapshot.data['name'],
        this.shortDescription = snapshot.data['shortDescription'],
        this.htmlDescription = snapshot.data['htmlDescription'],
        this.photoURL = snapshot.data['photoURL'],
        this.startTime = snapshot.data['startTime'],
        this.endTime = snapshot.data['endTime'] {
    Firestore.instance.collection('events/' + eventID + '/attendees').snapshots().listen((snapshot) => _attendeeStreamListener);
  }

  Future verifyTicket(String barcode) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('events/$eventID/attendees')
        .where("barcode", isEqualTo: barcode)
        .limit(1)
        .getDocuments();
    DocumentSnapshot attendee = snapshot.documents[0];
    if (attendee.data['uid'] != null) {
      throw ('Barcode already verified');
    }
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return attendee.reference.setData({
      "uid": currentUser.uid,
    }, merge: true);
  }

  Future<bool> isCurrentUserVerified() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    QuerySnapshot snapshot = await Firestore.instance
        .collection('events/$eventID/attendees')
        .where("uid", isEqualTo: currentUser.uid)
        .limit(1)
        .getDocuments();

    return snapshot.documents.length == 1;
  }

  void _attendeeStreamListener(QuerySnapshot snapshot) {
    int started = 0;
    int completed = 0;
    snapshot.documentChanges.forEach((attendeeSnapshot) {
      AttendeeModel a =
      AttendeeModel.fromFirebaseSnapshot(attendeeSnapshot.document);
      int foundAt = attendees.indexWhere((searchAttendee) =>
      searchAttendee.attendeeID == attendeeSnapshot.document.documentID);
      if (foundAt == -1) {
        attendees.add(a);
      } else {
        if (attendeeSnapshot.type == DocumentChangeType.removed) {
          attendees.removeAt(foundAt);
        } else {
          attendees[foundAt] = a;
          started++;
          a.refreshLinkedProfile().then((value) {
            completed++;
            if (started == completed && streamCallback != null) {
              streamCallback();
            }
          });
        }
      }
    });
  }
}
