import 'dart:async';
import 'dart:collection';

import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  List<ThreadModel> threads;
  Function callback = () => {};
  String currentUserId;
  StreamSubscription _childAddedSubscription;
  StreamSubscription _childChangedSubscription;
  DatabaseReference ref;
  List<EventModel> _eventList;

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
      print('Message service restarted');

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

    if (snapshot.value != null) {
      for(var key in snapshot.value.keys){
        dynamic value = snapshot.value[key];
      
        if(value['p'].length == participantMap.length && value['p'].length > 1){
          if(participantMap.keys.toSet().containsAll(value['p'].keys.toSet())){
            ThreadModel t = MessageService.instance.threads.singleWhere((element) => element.threadID == key);
            return t;
          }
        }
      }
    }

    //Create local thread if not exists
    otherParticipants.add(new UserProfile(currentUserId, null, null, null));
    return ThreadModel(otherParticipants);
  }
  
  List<UserProfile> userSearch() {
    List<UserProfile> users = [];
    _eventList = EventService.instance.events;
    String currentUser;
    for(int i = 0; i < _eventList.length; i++){
      if(_eventList[i].currentAttendee!=null){
        currentUser = _eventList[i].currentAttendee.name;
        for(int k = 0; k < _eventList[i].attendees.length;k++){
          if(!users.contains(_eventList[i].attendees[k])&&_eventList[i].attendees[k].name!=currentUser && _eventList[i].attendees[k].uid != null)
            users.add(_eventList[i].attendees[k]);
        }
      }
    }// attendees who are attending the same events
    // users.forEach((user) {
    //   if(!user.name.toLowerCase().contains(name.toLowerCase())){
    //     users.remove(user);
    //   }
    // });
    // Restrict user pool to people who are attending the same events.
    // String endKey = name.substring(0, name.length-1) + String.fromCharCode(name.codeUnitAt(name.length-1) + 1);
    // firestore.QuerySnapshot snapshot = await firestore.Firestore.instance.collection('users')
    //     .where("name", isGreaterThanOrEqualTo: name)
    //     .where("name", isLessThan: endKey)
    //     .getDocuments();
    // snapshot.documents.forEach((element) {
    //   users.add(UserProfile.fromFirestoreSnapshot(element));
    // });
    return users;
  }
}
