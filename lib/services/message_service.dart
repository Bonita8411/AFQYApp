import 'package:afqyapp/models/thread_model.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  List<ThreadModel> threads;
  Function listener = () => {};

  MessageService._privateConstructor() {
    threads = [];
    FirebaseDatabase.instance.reference().child('threads').onChildAdded.listen((snapshot) {
      threads.add(ThreadModel.fromSnapshot(snapshot.snapshot));
      listener();
    });
  }

  static final MessageService _instance = MessageService._privateConstructor();

  static MessageService get instance => _instance;

  Future newThread(List<String> participantIds) async {
    FirebaseDatabase.instance.reference().child('threads')
        .push()
        .set({
      "p": participantIds,
      "lm": '',
    });
  }
}