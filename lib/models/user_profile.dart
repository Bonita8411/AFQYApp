import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
  String uid;
  String name;
  String bio;
  String profilePictureURL;

  UserProfile(this.uid, this.name, this.bio, this.profilePictureURL);

  UserProfile.fromFirestoreSnapshot(DocumentSnapshot snapshot) :
    this.uid = snapshot.documentID,
    this.name = snapshot.data['name'],
    this.bio = snapshot.data['bio'],
    this.profilePictureURL = snapshot.data['photoURL'];

  Future refreshLinkedProfile() async {
    if(this.uid != null){
      DocumentSnapshot snapshot = await Firestore.instance.document('users/' + this.uid).get();
      if(snapshot.exists){
        this.profilePictureURL = snapshot.data['photoURL'];
        this.name = snapshot.data['name'];
        this.bio = snapshot.data['bio'];
      }
    }

    return this;
  }

  String toString(){
    return name != null ? name : 'Unknown';
  }
}