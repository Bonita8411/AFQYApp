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


  EventbriteEvent({this.title, this.description, this.descriptionHTML, this.location, this.startDT, this.endDT, this.url, this.hideStartTime, this.hideEndTime});
}