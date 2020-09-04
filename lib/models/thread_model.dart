import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ThreadModel{
  List<MessageModel> messages = [];
  List<String> participants = [];
  String threadID;
  String lastMessage;
  Function listener = () => {};

  ThreadModel.fromSnapshot(DataSnapshot snapshot) : 
    participants = [],
    threadID = snapshot.key,
    lastMessage = snapshot.value['lm']{
        FirebaseDatabase.instance.reference().child('messages').child(threadID).orderByChild('t').limitToLast(10).onChildAdded.listen((snapshot) {
          messages.insert(0, MessageModel.fromSnapshot(snapshot.snapshot));
          listener();
        });
    }

  void sendMessage(String message) async {
    String currentID;
    if(MessageService.instance.currentUser == null){
      FirebaseUser u = await FirebaseAuth.instance.currentUser();
      currentID = u.uid;
    }else{
      currentID = MessageService.instance.currentUser.uid;
    }
    FirebaseDatabase.instance.reference().child('messages')
        .child(this.threadID)
        .push()
        .set({
      "m": message,
      "s": currentID,
      "t": ServerValue.timestamp,
    });
    FirebaseDatabase.instance.reference().child('threads').child(threadID).update({
      "lm": message
    });
  }
}