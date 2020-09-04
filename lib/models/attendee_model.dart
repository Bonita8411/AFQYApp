import 'dart:collection';

import 'package:afqyapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendeeModel extends UserProfile {
  String attendeeID;
  String barcode;
  List<String> interests;
  bool isThisUser = false;
  HashSet<String> connectionIDs;
  bool isCurrentUser;
  bool isConnection;

  AttendeeModel.fromFirebaseSnapshot(DocumentSnapshot snapshot, bool isCurrentUser) :
    this.isCurrentUser = isCurrentUser,
    this.attendeeID = snapshot.documentID,
    this.barcode = snapshot.data['barcode'],
    this.interests = snapshot.data['interests'] != null ? snapshot.data['interests'].cast<String>() : [],
    this.connectionIDs = snapshot.data['connectionIDs'] != null ? HashSet.from(snapshot.data['connectionIDs'].cast<String>()) : HashSet(),
    super(snapshot.data['uid'], snapshot.data['name'], '', null);

  Future refreshLinkedProfile() async {
    if(this.uid != null){
      DocumentSnapshot snapshot = await Firestore.instance.document('users/' + this.uid).get();
      if(snapshot.exists){
        this.profilePictureURL = snapshot.data['photoURL'];
        this.name = snapshot.data['name'] != null ? snapshot.data['name'] : this.name;
        this.bio = snapshot.data['bio'];
      }
    }

    return this;
  }

  int computeSimilarInterestsNumber(AttendeeModel other){
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
}