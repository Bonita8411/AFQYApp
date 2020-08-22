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
}