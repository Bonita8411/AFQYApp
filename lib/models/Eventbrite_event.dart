import 'dart:convert';
import 'package:afqyapp/models/event_attendee.dart';
import 'package:afqyapp/services/eventbrite_service.dart';
import 'package:http/http.dart' as http;

class EventbriteEvent{
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

  EventbriteEvent({this.title, this.description, this.descriptionHTML, this.location, this.startDT, this.endDT, this.url, this.hideStartTime, this.hideEndTime, this.eventID});

  Future<List<EventAttendee>> getAttendees() async {
    if(_attendees != null){
      return _attendees;
    }
    return refreshAttendees();
  }

  Future<List<EventAttendee>> refreshAttendees() async {
    try{
      String attendeeURL = "https://www.eventbriteapi.com/v3/events/${this.eventID}/attendees/?token=" + EventbriteService.apiKey;
      print(attendeeURL);
      http.Response response = await http.get(attendeeURL);
      List eventbriteAttendees = json.decode(response.body)['attendees'];

      _attendees = [];
      eventbriteAttendees.forEach((attendee) {
        _attendees.add(new EventAttendee(
          name: attendee['profile']['name'],
          ticketID: attendee['order_id'],
        ));
      });

      return _attendees;
    }catch(e){
      throw("Error retrieving attendees");
    }
  }
}