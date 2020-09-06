import 'dart:async';
import 'dart:collection';

import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  List<ThreadModel> threads;
  Function callback = () => {};
  String currentUserId;
  StreamSubscription _childAddedSubscription;
  StreamSubscription _childChangedSubscription;
  DatabaseReference ref;

  MessageService._privateConstructor() {
    setCurrentUser();
  }

  static final MessageService _instance = MessageService._privateConstructor();

  static MessageService get instance => _instance;

  Future setCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      currentUserId = user.uid;
      threads = [];

      Query userThreadsQuery = FirebaseDatabase.instance.reference().child('threads').orderByChild('p/$currentUserId').equalTo(true);

      _childAddedSubscription?.cancel();
      _childAddedSubscription = userThreadsQuery.onChildAdded.listen((threadEvent) {
        threads.add(ThreadModel.fromSnapshot(threadEvent.snapshot));
      });

//      _childChangedSubscription.cancel();
//      _childChangedSubscription = userThreadsQuery.onChildChanged.listen((threadEvent) async {
//        ThreadModel changedThread =
//      });
    });
  }

  Future<ThreadModel> newThread(List<UserProfile> otherParticipants) async {
    //Construct map with current user and participants
    Map participantMap = Map.fromIterable(otherParticipants, key: (k) => k.uid, value: (v) => true);
    participantMap[currentUserId] = true;
    //Return thread if exists
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('threads').orderByChild('p/$currentUserId').equalTo(true).once();

    for(var key in snapshot.value.keys){
      dynamic value = snapshot.value[key];

      if(value['p'].length == participantMap.length){
        if(participantMap.keys.toSet().containsAll(value['p'].keys.toSet())){
          ThreadModel t = MessageService.instance.threads.singleWhere((element) => element.threadID == key);
          return t;
        }
      }
    }

    //Create local thread if not exists
    otherParticipants.add(new UserProfile(currentUserId, null, null, null));
    return ThreadModel(otherParticipants);
  }
}
