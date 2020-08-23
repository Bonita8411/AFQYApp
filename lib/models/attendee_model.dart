import 'package:afqyapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendeeModel extends UserProfile {
  String attendeeID;
  String barcode;
  List<String> interests;
  bool isThisUser = false;
  List<String> connectionIDs;
  bool isCurrentUser;

  AttendeeModel.fromFirebaseSnapshot(DocumentSnapshot snapshot, bool isCurrentUser) :
    this.isCurrentUser = isCurrentUser,
    this.attendeeID = snapshot.documentID,
    this.barcode = snapshot.data['barcode'],
    this.interests = snapshot.data['interests'] != null ? snapshot.data['interests'].cast<String>() : [],
    this.connectionIDs = snapshot.data['connectionIDs'] != null ? snapshot.data['connectionIDs'].cast<String>() : [],
    super(snapshot.data['uid'], snapshot.data['name'], '', '');

  Future refreshLinkedProfile() async {
    if(this.uid != null){
      DocumentSnapshot snapshot = await Firestore.instance.document('users/' + this.uid).get();
      this.profilePictureURL = snapshot.data['photoURL'];
      this.name = snapshot.data['name'] != null ? snapshot.data['name'] : this.name;
      this.bio = snapshot.data['bio'];
    }

    return this;
  }
}