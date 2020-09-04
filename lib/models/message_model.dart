import 'package:firebase_database/firebase_database.dart';

class MessageModel{
  String senderID;
  String message;
  DateTime time;

  MessageModel.fromSnapshot(DataSnapshot snapshot):
    senderID = snapshot.value['s'],
    message = snapshot.value['m'],
    time = DateTime.fromMillisecondsSinceEpoch(snapshot.value['t']).toLocal();
}