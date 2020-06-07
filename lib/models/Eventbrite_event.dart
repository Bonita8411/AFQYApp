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
      String attendeeURL =
          "https://www.eventbriteapi.com/v3/events/${this.eventID}/attendees/?token=" +
              EventbriteService.apiKey;
      http.Response response = await http.get(attendeeURL);
      List eventbriteAttendees = json.decode(response.body)['attendees'];

      _attendees = [];
      eventbriteAttendees.forEach((attendee) {
        _attendees.add(new EventAttendee(
            name: attendee['profile']['name'],
            ticketID: attendee['order_id'],
            interests: []));
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

        if (ticketNumber == attendee.ticketID) {
          found = true;
          //Get current user
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
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
}
