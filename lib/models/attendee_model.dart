import 'package:afqyapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendeeModel extends UserProfile {
  String attendeeID;
  String barcode;
  List<String> interests;
  bool isThisUser = false;

  AttendeeModel(uid, name, bio, profilePictureURL, this.attendeeID, this.barcode,
      this.interests) : super(uid, name, bio, profilePictureURL);

  AttendeeModel.fromFirebaseSnapshot(DocumentSnapshot snapshot) :
    this.attendeeID = snapshot.documentID,
    this.barcode = snapshot.data['barcode'],
    this.interests = snapshot.data['interests'] != null ? snapshot.data['interests'] : [],
    super(snapshot.data['uid'], snapshot.data['name'], '', '');

  Future refreshLinkedProfile() async {
    if(this.uid != null){
      DocumentSnapshot snapshot = await Firestore.instance.document('users/' + this.uid).get();
      this.profilePictureURL = snapshot.data['photoURL'];
      this.name = snapshot.data['name'];
      this.bio = snapshot.data['bio'];
    }

    return this;
  }
}