import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/services.dart';

class AuthService{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseUser currentUser;
  static String notificationToken;

  static Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } on PlatformException catch (e) {
      String errorMessage;
      switch(e.code){
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_USER_NOT_FOUND':
          errorMessage = "Email or Password is incorrect";
          break;
        default:
          errorMessage = e.message;
          break;
      }
      throw(errorMessage);
    }
  }

  static Future<FirebaseUser> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //Add the user's name to the recently created user
      Firestore.instance.document('users/${user.uid}').setData({
        'name': name,
      });

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = name;
      user.updateProfile(updateInfo);
      user.reload();
      return user;
    } on PlatformException catch (e) {
      String errorMessage;
      switch(e.code){
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "An account with that email already exists";
          break;
        default:
          errorMessage = e.message;
      }
      throw(errorMessage);
    }
  }

  static Future signOut() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.document('users/${user.uid}').updateData({"notificationTokens" : FieldValue.arrayRemove([notificationToken])});
    return await _firebaseAuth.signOut();
  }

  static Future<FirebaseUser> signInAnon() async {
    AuthResult result = await _firebaseAuth.signInAnonymously();
    FirebaseUser user = result.user;
    return user;
  }

  static Future resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}