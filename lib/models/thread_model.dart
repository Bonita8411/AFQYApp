import 'package:afqyapp/models/message_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ThreadModel{
  List<MessageModel> messages = [];
  List<String> participants = [];
  String threadID;
  String lastMessage;
  Function listener = () => {};


  ThreadModel.fromSnapshot(DataSnapshot snapshot) : 
    participants = snapshot.value['p'].cast<String>().toList(),
    threadID = snapshot.key,
    lastMessage = snapshot.value['lm']{
        FirebaseDatabase.instance.reference().child('messages').child(threadID).orderByChild('t').limitToLast(10).onChildAdded.listen((snapshot) {
          messages.insert(0, MessageModel.fromSnapshot(snapshot.snapshot));
          listener();
        });
    }

  void sendMessage(String message, String senderID) async {
    FirebaseDatabase.instance.reference().child('messages')
        .child(this.threadID)
        .push()
        .set({
      "m": message,
      "s": senderID,
      "t": ServerValue.timestamp,
    });
    FirebaseDatabase.instance.reference().child('threads').child(threadID).update({
      "lm": message
    });
  }
}