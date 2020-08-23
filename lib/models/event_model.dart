import 'package:afqyapp/models/event_attendee.dart';
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
  AttendeeModel currentAttendee;

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
    attendees.sort((a, b) => a.name.compareTo(b.name));
  }

  void sortAttendeesZtoA() {
    attendees.sort((a, b) => b.name.compareTo(a.name));
  }

  void sortAttendeesByInterest() {
    attendees.sort((a, b) => b.computeSimilarInterestsNumber(currentAttendee).compareTo(a.computeSimilarInterestsNumber(currentAttendee)));
  }

  Future addConnection(String connectionID) async{
      return Firestore.instance.document('${EventService.instance.eventCollection}/$eventID/attendees/${currentAttendee.attendeeID}').setData({
        "connectionIDs": FieldValue.arrayUnion([connectionID])
      }, merge: true);
  }

  Future removeConnection(String connectionID) async{
    return Firestore.instance.document('${EventService.instance.eventCollection}/$eventID/attendees/${currentAttendee.attendeeID}').setData({
      "connectionIDs": FieldValue.arrayRemove([connectionID])
    }, merge: true);
  }

  Future<List> updateInterests(List interests) async {
    //Update interests
    await Firestore.instance.document('${EventService.instance.eventCollection}/${this.eventID}/attendees/${currentAttendee.attendeeID}').updateData({
      'interests': interests,
    });
    return interests;
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
      if(isCurrentUser){
        currentAttendee = a;
      }
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
          completed++;
          if (started == completed && streamCallback != null) {
            streamCallback();
          }
        });
      }
    });

    //Set connections
    attendees.forEach((element) {
      element.isConnection = currentAttendee.connectionIDs.contains(element.attendeeID);
    });
  }
}
