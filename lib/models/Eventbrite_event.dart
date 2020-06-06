import 'package:afqyapp/models/event_attendee.dart';

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
  List<EventAttendee> attendees = [];

  EventbriteEvent({this.title, this.description, this.descriptionHTML, this.location, this.startDT, this.endDT, this.url, this.hideStartTime, this.hideEndTime, this.eventID});
}