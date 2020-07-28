class EventAttendee with Comparable<EventAttendee>{
  String name;
  String ticketID;
  List<String> interests = [];
  bool verified;
  bool saved;

  EventAttendee({this.name, this.ticketID, this.interests, this.verified = false, this.saved = false});

  @override
  int compareTo(EventAttendee other) {
    return this.name.compareTo(other.name);
  }
}