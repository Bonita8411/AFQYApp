import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageNotificationService {
  static Future<String> registerNotification() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();

    String token = await _firebaseMessaging.getToken();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.document('users/${user.uid}').setData({"notificationTokens" : FieldValue.arrayUnion([token]) }, merge: true);

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    });

    print('notification Serivce registered');
    return token;
  }
}
