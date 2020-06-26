import 'dart:convert';
import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  List<EventAttendee> _connections = [];

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
      this.eventID});

  Future<List<EventAttendee>> getAttendees() async {
    if (_attendees != null) {
      return _attendees;
    }
    return refreshAttendees();
  }

  Future<List<EventAttendee>> refreshAttendees() async {
    try {
      //Get eventbrite attendees
      String attendeeURL =
          "https://www.eventbriteapi.com/v3/events/${this.eventID}/attendees/?token=" +
              EventbriteService.apiKey;
      http.Response response = await http.get(attendeeURL);
      List eventbriteAttendees = json.decode(response.body)['attendees'];

      //Get firebase attendees
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
          if(verifiedAttendee.documentID == attendee['barcodes'][0]['barcode']){
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
      QuerySnapshot tickets = await Firestore.instance
          .collection('events')
          .document(this.eventID)
          .collection('attendees')
          .where("uid", isEqualTo: user.uid)
          .limit(1)
          .getDocuments();
      return tickets.documents.length == 1;
    } catch (e) {
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
              .document(ticketNumber)
              .setData({
                "uid": user.uid,
                "interests": ["", "", ""]
          });
        }
      }
      return found;
    } catch (e) {
      throw ("Error verifying ticket, please try again");
    }
  }

  Future<List<EventAttendee>> getConnections() async{
    if(_connections.length > 0){
      return _connections;
    }else{
      return refreshConnections();
    }
  }

  Future<List<EventAttendee>> refreshConnections() async{
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot snapshot = await Firestore.instance.collection('events').document(this.eventID).collection('attendees').document(user.uid).get();
      List connectionIDs = snapshot.data['connections'];
      _connections = [];
      if(_attendees == null){
        getAttendees();
      }
      if(connectionIDs != null){
        connectionIDs.forEach((connectionId) {
          _attendees.forEach((attendee) {
            if(connectionId == attendee.ticketID){
              _connections.add(attendee);
            }
          });
        });
      }
      return _connections;
    }catch(e){
      print(e);
    }
  }
  
  Future addConnection(EventAttendee connection) async{
    //add connection to array
    _connections.add(connection);

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
    //add connection to firebase
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance.collection('events').document(this.eventID).collection('attendees').document(user.uid).setData({
        "connections": FieldValue.arrayRemove([connection.ticketID])
      }, merge: true);
    }catch(e){
      throw('Error removing connection');
    }
  }
}
