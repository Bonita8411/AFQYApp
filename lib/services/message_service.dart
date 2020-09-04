import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  List<ThreadModel> threads;
  Function listener = () => {};
  UserProfile currentUser;
  bool _loaded = false;

  MessageService._privateConstructor() {
    threads = [];
  }

  static final MessageService _instance = MessageService._privateConstructor();

  static MessageService get instance => _instance;

  Future<ThreadModel> newThread(List<String> otherParticipantIds) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference threadRef = FirebaseDatabase.instance
        .reference()
        .child('threads')
        .orderByChild(currentUser.uid)
        .equalTo(true).reference();
    DataSnapshot snapshot = await threadRef.once();

    bool found = false;
    snapshot.value?.forEach((key, threadContent) {
      int sameIds = 0;
      otherParticipantIds.forEach((element) {
        threadContent.keys.forEach((idKey){
          if(element == idKey){
            sameIds++;
            threadRef = FirebaseDatabase.instance.reference().child('threads').child(key).reference();
          }
        });
      });
      found = threadContent.length == otherParticipantIds.length + 2 && otherParticipantIds.length == sameIds;
    });

    snapshot = await threadRef.once();

    if(!found){
      Map threadMap = Map.fromIterable(otherParticipantIds,
          key: (e) => e, value: (e) => true);
      threadMap['lm'] = "Start a conversation...";
      threadMap[currentUser.uid] = true;
      DatabaseReference threadRef = FirebaseDatabase.instance
          .reference()
          .child('threads')
          .push()
          .reference();
      threadRef.set(threadMap);
      snapshot = await threadRef.once();
    }
    ThreadModel tm = new ThreadModel.fromSnapshot(snapshot);
    return tm;
  }

  void loadThreads() {
    if (!_loaded && currentUser != null) {
      _loaded = true;
      FirebaseDatabase.instance
          .reference()
          .child('threads')
          .orderByChild(currentUser.uid)
          .equalTo(true)
          .onChildAdded
          .listen((snapshot) async {
        threads.add(ThreadModel.fromSnapshot(snapshot.snapshot));
        listener();
      });
    }
  }
}
