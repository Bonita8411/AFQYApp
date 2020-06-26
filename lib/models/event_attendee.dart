class EventAttendee{
  String name;
  String ticketID;
  List<String> interests = [];
  bool verified;
  bool saved;
  List<EventAttendee> connections = [];

  EventAttendee({this.name, this.ticketID, this.interests, this.verified = false, this.saved = false, this.connections});

  Future addConnection(String ticketID) async{

  }
}