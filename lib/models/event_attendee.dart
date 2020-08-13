import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventAttendee{
  String name;
  String ticketID;
  List<String> interests = [];
  bool verified;
  bool saved;
  String profileImage;
  String uid;
  bool current;

  EventAttendee({this.name, this.ticketID, this.interests, this.verified = false, this.saved = false, this.profileImage = '', uid = '', this.current = false});

  int computeSimilarInterestsNumber(EventAttendee other){
    int numSameInterests = 0;
    this.interests.forEach((thisInterest) {
      other.interests.forEach((otherInterest) {
        if(thisInterest == otherInterest){
          numSameInterests++;
        }
      });
    });

    return numSameInterests;
  }
  
  int compareToInterests(EventAttendee other, EventAttendee userAttendee){
    return other.computeSimilarInterestsNumber(userAttendee).compareTo(this.computeSimilarInterestsNumber(userAttendee));
  }

  int compareToNameAtoZ(EventAttendee other) {
    return this.name.compareTo(other.name);
  }

  int compareToNameZtoA(EventAttendee other) {
    return other.name.compareTo(this.name);
  }
}