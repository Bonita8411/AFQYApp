import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
  String name;
  String bio;
  String profilePictureURL;

  UserProfile(this.name, this.bio, this.profilePictureURL);

  UserProfile.fromFirestoreSnapshot(DocumentSnapshot snapshot) :
    this.name = snapshot.data['name'],
    this.bio = snapshot.data['bio'],
    this.profilePictureURL = snapshot.data['photoURL'];
}