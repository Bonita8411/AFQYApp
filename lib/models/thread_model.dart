import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ThreadModel {
  List<MessageModel> messages = [];
  List<UserProfile> participants = [];
  String threadID;
  String lastMessage;
  Function viewStateListener = () => {};
  DatabaseReference ref;
  bool isNew = true;

  ThreadModel(this.participants);

  ThreadModel.fromSnapshot(DataSnapshot snapshot) :
      isNew = false,
      threadID = snapshot.key,
      lastMessage = snapshot.value['lm'],
      participants = snapshot.value['p'].keys
          .map<UserProfile>((uid) => new UserProfile(uid, null, null, null)).toList(),
      ref = FirebaseDatabase.instance.reference().child('threads/${snapshot.key}').reference() {
      _addListeners();
  }

  void sendMessage(String message) async {
    if(isNew){
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
    ref.update({"lm": message});
  }

  String participantsToString(){
    List otherParticipants = participants.where((element) => element.uid != MessageService.instance.currentUserId).toList();
    return otherParticipants.join(', ');
  }

  void _addListeners(){
    ref.child('lm').onValue.listen((event) => _handleOnLastMessage(event.snapshot));
    ref.child('p').onValue.listen((event) => _handleOnParticipant(event.snapshot));
    FirebaseDatabase.instance.reference().child('messages/$threadID').orderByChild('t').limitToLast(10)
        .onChildAdded.listen((event) => _handleOnMessage(event.snapshot));
  }

  void _handleOnLastMessage(DataSnapshot snapshot){
    this.lastMessage = snapshot.value;
    viewStateListener();
  }

  void _handleOnParticipant(DataSnapshot snapshot){
    participants = snapshot.value.keys.map<UserProfile>((uid) => new UserProfile(uid, null, null, null)).toList();

    //Load all profiles' data and refresh the state when done
    int profilesRefreshed = 0;
    participants.forEach((participant) {
      participant.refreshLinkedProfile().then((value) {
        profilesRefreshed++;
        if(profilesRefreshed == participants.length){
          viewStateListener();
        }
      });
    });
  }

  void _handleOnMessage(DataSnapshot snapshot){
    messages.insert(0, MessageModel.fromSnapshot(snapshot));
    viewStateListener();
  }

  Future _uploadThread() async {
    ref = FirebaseDatabase.instance.reference().child('threads').push().reference();
    Map participantsMap = Map.fromIterable(participants, key: (k) => k.uid, value: (v) => true);
    await ref.set({
      'lm': '',
      'p': participantsMap
    });
    DataSnapshot snapshot = await ref.once();
    threadID = snapshot.key;
    isNew = false;
    _addListeners();
  }

  Future deleteThread() async {
    return ref.remove();
  }
}
