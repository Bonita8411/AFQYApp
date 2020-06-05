import 'dart:convert';
import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:http/http.dart' as http;

class EventbriteService{
  static String _apiKey = "OYFDYJB7SMZ2VFQG5CO6";
  static List<EventbriteEvent> _loadedEvents = [];

  static Future<List<EventbriteEvent>> getEvents() async {
    if(_loadedEvents.length > 0){
      return _loadedEvents;
    }
    return await refreshEvents();
  }

  static Future<List<EventbriteEvent>> refreshEvents() async{
    try {
      String eventListUrl = "https://www.eventbriteapi.com/v3/organizations/47604957273/events/?expand=venue&order_by=start_desc&status=live&token=" + _apiKey;
      http.Response response = await http.get(eventListUrl);
      List events = json.decode(response.body)['events'];

      _loadedEvents = [];
      events.forEach((event) {
        String location = "";
        if (event["online_event"] == true) {
          location = "Online Event";
        }
        else if (event["venue"] == null) {
          location = "TBA";
        }
        else {
          location = event["venue"]["name"];
        }

        EventbriteEvent eventbriteEvent = new EventbriteEvent(
          title: event["name"]["text"],
          description: event["description"]["text"],
          descriptionHTML: event["description"]["html"],
          startDT: DateTime.parse(event["start"]["local"]),
          endDT: DateTime.parse(event["end"]["local"]),
          hideStartTime: event["hide_start_date"],
          hideEndTime: event["hide_end_date"],
          url: event["url"],
          location: location
        );
        _loadedEvents.add(eventbriteEvent);
      });
      if(_loadedEvents.length < 1){
        throw("No Events Found");
      }
      return _loadedEvents;
    }catch (e) {
      throw("CONNECTION ERROR");
    }
  }
}