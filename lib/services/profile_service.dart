import 'dart:io';

import 'package:afqyapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService{
  Future updateProfilePicture(File image) async {
    try{      
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      
      //Upload to Firebase Storage
      StorageReference fsRef = FirebaseStorage.instance.ref().child('profiles/' + currentUser.uid);
      StorageUploadTask uploadTask = fsRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      //Get upload url
      String profilePictureURL = await fsRef.getDownloadURL();

      //Update Auth profile object
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      userUpdateInfo.photoUrl = profilePictureURL;
      currentUser.updateProfile(userUpdateInfo);

      //Update Firestore reference
      await Firestore.instance.document('users/' + currentUser.uid).setData({
        "photoURL": profilePictureURL
      }, merge: true);

    }catch (e){
      print(e);
      throw(e);
    }
  }

  Future updateBio(String bio) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.document('users/' + currentUser.uid).setData({
      "bio": bio
    }, merge: true);
  }

  Future<UserProfile> getCurrentUserProfile() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snapshot = await Firestore.instance.document('users/' + currentUser.uid).get();
    return UserProfile.fromFirestoreSnapshot(snapshot);
  }
}