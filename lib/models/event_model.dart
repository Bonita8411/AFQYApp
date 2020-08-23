import 'package:afqyapp/services/event_service.dart';
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
  String location;
  List<AttendeeModel> attendees = [];
  Function streamCallback;
  bool _hasStartedLoadingAttendees = false;

  EventModel.fromFirestoreSnapshot(DocumentSnapshot snapshot)
      : this.eventID = snapshot.documentID,
        this.name = snapshot.data['title'],
        this.shortDescription = snapshot.data['description'],
        this.htmlDescription = snapshot.data['htmlDescription'],
        this.photoURL = snapshot.data['imageURL'],
        this.startTime = DateTime.parse(snapshot.data['startDT']),
        this.endTime = DateTime.parse(snapshot.data['endDT']),
        this.location = snapshot.data['location'] != null
            ? snapshot.data['location']
            : 'TBA';

  Future verifyTicket(String barcode) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(
            '${EventService.instance.eventCollection}/$eventID/attendees')
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
        .collection(
            '${EventService.instance.eventCollection}/$eventID/attendees')
        .where("uid", isEqualTo: currentUser.uid)
        .limit(1)
        .getDocuments();

    return snapshot.documents.length == 1;
  }

  void sortAttendeesAtoZ() {
    print('a-z sort');
  }

  void sortAttendeesZtoA() {
    print('z-a sort');
  }

  void sortAttendeesByInterest() {
    print('interest sort');
  }

  void startLoadingAttendees(){
    if(!_hasStartedLoadingAttendees){
      _hasStartedLoadingAttendees = true;
      Firestore.instance
          .collection(EventService.instance.eventCollection +
          '/' +
          eventID +
          '/attendees')
          .snapshots()
          .listen((snapshot) => _onAttendee(snapshot));
    }
  }

  void _onAttendee(QuerySnapshot snapshot) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    int started = 0;
    int completed = 0;
    snapshot.documentChanges.forEach((attendeeSnapshot) {
      bool isCurrentUser = currentUser.uid == attendeeSnapshot.document['uid'];
      AttendeeModel a =
      AttendeeModel.fromFirebaseSnapshot(attendeeSnapshot.document, isCurrentUser);
      int foundAt = attendees.indexWhere((searchAttendee) =>
      searchAttendee.attendeeID == attendeeSnapshot.document.documentID);
      if (attendeeSnapshot.type == DocumentChangeType.removed) {
        attendees.removeAt(foundAt);
      } else {
        if (foundAt == -1) {
          attendees.add(a);
        } else {
          attendees[foundAt] = a;
        }
        started++;
        a.refreshLinkedProfile().then((value) {
          print('refreshing');
          completed++;
          if (started == completed && streamCallback != null) {
            streamCallback();
          }
        });
      }
    });
  }
}
