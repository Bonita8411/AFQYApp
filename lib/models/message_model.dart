import 'package:firebase_database/firebase_database.dart';

class MessageModel{
  String senderID;
  String message;
  int timestamp;
  DateTime time;
  String messageID;

  MessageModel.fromSnapshot(DataSnapshot snapshot):
    senderID = snapshot.value['s'],
    message = snapshot.value['m'],
    timestamp = snapshot.value['t'],
    time = DateTime.fromMillisecondsSinceEpoch(snapshot.value['t']).toLocal(),
    messageID = snapshot.key;
}