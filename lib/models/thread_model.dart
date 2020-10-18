import 'dart:async';

import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class ThreadModel {
  List<MessageModel> messages = [];
  List<UserProfile> participants = [];
  String threadID;
  String lastMessage;
  Function threadsStateListener = () => {};
  Function threadStateListener = () => {};
  DatabaseReference ref;
  bool isNew = true;
  bool isRead = false;
  int lastMessageTimestamp;
  String owner;
  int loadedTimestamp = 0;

  ThreadModel(this.participants);

  ThreadModel.fromSnapshot(DataSnapshot snapshot)
      : isNew = false,
        threadID = snapshot.key,
        lastMessage = snapshot.value['lm'],
        participants = snapshot.value['p'].keys
            .map<UserProfile>((uid) => new UserProfile(uid, null, null, null))
            .toList(),
        lastMessageTimestamp = snapshot.value['lmTime'],
        owner = snapshot.value['owner'],
        ref = FirebaseDatabase.instance
            .reference()
            .child('threads/${snapshot.key}')
            .reference() {
    _addListeners();
  }

  void sendMessage(String message) async {
    if (isNew) {
      await _uploadThread();
    }
    FirebaseDatabase.instance
        .reference()
        .child('messages/$threadID')
        .push()
        .set({
      "m": message,
      "s": MessageService.instance.currentUserId,
      "t": ServerValue.timestamp,
    });
    ref.update({
      "lm": message,
      "lmUID": MessageService.instance.currentUserId,
      "lmTime": ServerValue.timestamp
    });
  }

  void updateReadTimestamp() {
    if(ref != null){
      ref
        .child('timestamps')
        .update({MessageService.instance.currentUserId: ServerValue.timestamp});
    }
  }

  String participantsToString() {
    List otherParticipants = participants
        .where(
            (element) => element.uid != MessageService.instance.currentUserId)
        .toList();
    return otherParticipants.join(', ');
  }

  void _addListeners() {
    ref.onValue
        .listen((event) => _handleOnLastMessage(event.snapshot));
    ref
        .child('p')
        .onValue
        .listen((event) => _handleOnParticipant(event.snapshot));
    FirebaseDatabase.instance
        .reference()
        .child('messages/$threadID')
        .orderByChild('t')
        .limitToLast(20)
        .onChildAdded
        .listen((event) => _handleOnMessage(event.snapshot));
  }

  void _handleOnLastMessage(DataSnapshot snapshot) {
    this.isRead = snapshot.value['timestamps'][MessageService.instance.currentUserId] >= snapshot.value['lmTime']
        || snapshot.value['lmUID'] == MessageService.instance.currentUserId;
    this.lastMessage = snapshot.value['lm'];
    this.lastMessageTimestamp = snapshot.value['lmTime'];
    threadsStateListener();
  }

  void _handleOnParticipant(DataSnapshot snapshot) {
    participants = snapshot.value.keys
        .map<UserProfile>((uid) => new UserProfile(uid, null, null, null))
        .toList();

    //Load all profiles' data and refresh the state when done
    int profilesRefreshed = 0;
    participants.forEach((participant) {
      participant.refreshLinkedProfile().then((value) {
        profilesRefreshed++;
        if (profilesRefreshed == participants.length) {
          threadsStateListener();
          threadStateListener();
        }
      });
    });
  }

  void _handleOnMessage(DataSnapshot snapshot) {
    messages.insert(0, MessageModel.fromSnapshot(snapshot));
    loadedTimestamp = messages[messages.length-1].timestamp-1;
    threadStateListener();
  }

  Future _uploadThread() async {
    ref = FirebaseDatabase.instance
        .reference()
        .child('threads')
        .push()
        .reference();
    Map participantsMap =
        Map.fromIterable(participants, key: (k) => k.uid, value: (v) => true);
    await ref.set({
      'lm': '',
      'p': participantsMap,
      'owner': MessageService.instance.currentUserId
    });
    DataSnapshot snapshot = await ref.once();
    threadID = snapshot.key;
    isNew = false;
    _addListeners();
  }

  Future deleteThread() async {
    return ref.remove();
  }

  Future addUsers(List userIds) async {
    if (isNew) {
      await _uploadThread();
    }
    for (int i = 0; i < userIds.length; i++) {
      await ref.child('p/${userIds[i]}').set(true);
    }
  }

  Future removeUser(String uid) async {
    if(uid == owner){
      ref.child('owner').set(participants.firstWhere((element) => element.uid != owner));
    }
    return ref.child('p/$uid').remove();
  }

  Future reportMessage(MessageModel message, String reason) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return http.get('https://us-central1-afqy-app.cloudfunctions.net/redCard?name=${user.displayName}&email=${user.email}&reason=$reason&threadID=$threadID&message=${message.message}&messageID=${message.messageID}');
  }

  Future loadMoreMessages() async {
    List<MessageModel> loadedMessages = [];
    var query = FirebaseDatabase.instance
        .reference()
        .child('messages/$threadID')
        .orderByChild('t')
        .endAt(loadedTimestamp)
        .limitToLast(20);
      query.onChildAdded.forEach((snapshot){
          loadedMessages.insert(0, MessageModel.fromSnapshot(snapshot.snapshot));
    });
    query.once().then((snapshot) {
      messages.addAll(loadedMessages);
      loadedTimestamp = messages[messages.length-1].timestamp -1;
      threadStateListener();
    });
//        _handleOnMessage(event.snapshot);
  }
}
