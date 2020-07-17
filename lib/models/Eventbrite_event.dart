import 'dart:convert';
import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class EventbriteEvent {
  final String title;
  final String description;
  final String descriptionHTML;
  final String location;
  final DateTime startDT;
  final DateTime endDT;
  final String url;
  final bool hideStartTime;
  final bool hideEndTime;
  final String eventID;
  List<EventAttendee> _attendees;
  String imageURL;

  EventbriteEvent(
      {this.title,
      this.description,
      this.descriptionHTML,
      this.location,
      this.startDT,
      this.endDT,
      this.url,
      this.hideStartTime,
      this.hideEndTime,
      this.eventID,
      this.imageURL});

  Future<List<EventAttendee>> getAttendees() async {
    if (_attendees != null) {
      return _attendees;
    }
    return refreshAttendees();
  }

  Future<List<EventAttendee>> refreshAttendees() async {
    try {
      //Get eventbrite attendees
      bool hasMoreItems = true;
      String continuationToken = "";
      List eventbriteAttendees = [];

      while(hasMoreItems){
        String attendeeURL =
            "https://www.eventbriteapi.com/v3/events/${this.eventID}/attendees/?token=" +
                EventbriteService.apiKey
                + "&continuation=${continuationToken}";
        http.Response response = await http.get(attendeeURL);
        eventbriteAttendees += json.decode(response.body)['attendees'];

        hasMoreItems = json.decode(response.body)['pagination']['has_more_items'];
        continuationToken = json.decode(response.body)['pagination']['continuation'];
      }

      //Get firebase attendees
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      QuerySnapshot verifiedAttendees = await Firestore.instance.collection('events').document(this.eventID).collection('attendees').getDocuments();

      _attendees = [];
      eventbriteAttendees.forEach((attendee) {
        //Check if eventbrite ticket is in firestore
        EventAttendee newAttendee = new EventAttendee(
            name: attendee['profile']['name'],
            ticketID: attendee['barcodes'][0]['barcode'],
            interests: []
        );
        verifiedAttendees.documents.forEach((verifiedAttendee) {
          if(verifiedAttendee.documentID == user.uid){
            if(verifiedAttendee.data['connections'] != null){
              verifiedAttendee.data['connections'].forEach((connectionID){
                if(connectionID == newAttendee.ticketID){
                  newAttendee.saved = true;
                }
              });
            }
          }
          if(verifiedAttendee.data['barcode'] == newAttendee.ticketID){
            newAttendee.interests = List.from(verifiedAttendee.data['interests']);
            newAttendee.verified = true;
          }
        });
        _attendees.add(newAttendee);
      });

      return _attendees;
    } catch (e) {
      throw ("Error retrieving attendees");
    }
  }

  Future<bool> checkTicket() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot ticket = await Firestore.instance
          .collection('events')
          .document(this.eventID)
          .collection('attendees')
          .document(user.uid).get();
      return (ticket.data != null && ticket.data['barcode'] != null && !ticket.data['barcode'].isEmpty);
    } catch (e) {
      print(e);
      throw ("Error checking ticket");
    }
  }

  Future<bool> verifyTicket(String ticketNumber) async {
    //Refresh attendee list
    try {
      List<EventAttendee> attendees = await refreshAttendees();
      Iterator attendeesIterator = attendees.iterator;
      bool found = false;
      while (attendeesIterator.moveNext() && !found) {
        EventAttendee attendee = attendeesIterator.current;

        if (!attendee.verified && ticketNumber == attendee.ticketID) {
          found = true;
          //Get current user
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          //Check if ticket is already in firestore

          //Add ticket to firestore
          await Firestore.instance
              .collection('events')
              .document(this.eventID)
              .collection('attendees')
              .document(user.uid)
              .setData({
                "barcode": ticketNumber,
                "interests": ["", "", ""]
          });
        }
      }
      return found;
    } catch (e) {
      throw ("Error verifying ticket, please try again");
    }
  }
  
  Future addConnection(EventAttendee connection) async{
    connection.saved = true;

    //add connection to firebase
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance.collection('events').document(this.eventID).collection('attendees').document(user.uid).setData({
        "connections": FieldValue.arrayUnion([connection.ticketID])
      }, merge: true);
    }catch(e){
      throw('Error saving connection');
    }
  }

  Future removeConnection(EventAttendee connection) async{
    connection.saved = false;

    //remove connection from firebase
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance.collection('events').document(this.eventID).collection('attendees').document(user.uid).setData({
        "connections": FieldValue.arrayRemove([connection.ticketID])
      }, merge: true);
    }catch(e){
      throw('Error removing connection');
    }
  }

  Future<List> retrieveInterests() async{
    //Get firebase user
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      //Retrieve Interests
      DocumentSnapshot documentSnapshot = await Firestore.instance.document('events/${this.eventID}/attendees/${user.uid}').get();
      return documentSnapshot.data['interests'];
  }

  Future<List> updateInterests(List interests) async {
    //Get firebase user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //Update interests
    await Firestore.instance.document('events/${this.eventID}/attendees/${user.uid}').updateData({
      'interests': interests,
    });
    return interests;
  }
}
