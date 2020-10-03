import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/screens/chat/add_user_screen.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:flutter/material.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadModel thread;

  ThreadScreen(this.thread);

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  String messageInput = '';
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  void initState() {
    widget.thread.threadStateListener = () => setState(() {});
    widget.thread.updateReadTimestamp();
    super.initState();
  }

  @override
  void dispose() {
    widget.thread.threadStateListener = () => {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThreadModel thread = widget.thread;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: thread.isNew ? Text('Create new message') : Text(thread.participantsToString()),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _openEndDrawer()
            ),
          ),
        ],
      ),
        endDrawer: SafeArea(
          child: Drawer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                    child: Text('Participants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text('Add User'),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddUserScreen(thread),
                            ));
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: thread.participants.length,
                      itemBuilder: (context, index){
                        UserProfile user = thread.participants[index];
                        return Card(
                          child: ListTile(
                            title: Text(user.toString()),
                            leading: CircleAvatar(
                              backgroundColor: Colors.red[900],
                              child: ClipOval(
                                child: user.profilePictureURL != null ?
                                FadeInImage.assetNetwork(
                                  image: user.profilePictureURL,
                                  placeholder: 'assets/images/profile.png',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset('assets/images/profile.png',
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ),
                            trailing: FlatButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete),
                                  Text('Remove',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.grey[600]
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () async {
                                await thread.removeUser(user.uid);
                                setState(() {

                                });
                              },
                            ),
                          ),
                        );
                      },
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text('Leave Conversation'),
                      onPressed: (){
                        _showLeaveDialog().then((value) async {
                          if(value){
                            await thread.removeUser(MessageService.instance.currentUserId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      body: Column(
        children: [
          Expanded(
            child: thread.isNew ? Center(child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddUserScreen(thread),
                    ));
              },
              child: Text('Add people to this chat'),
            ))
                : ListView.builder(
              reverse: true,
              itemCount: thread.messages.length,
              itemBuilder: (context, index){
                MessageModel message = thread.messages[index];
                bool fromCurrent = MessageService.instance.currentUserId == message.senderID;
                UserProfile user = thread.participants.singleWhere((element) => element.uid == message.senderID);
                return Align(
                  alignment: fromCurrent ? Alignment.centerRight : Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.0,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                          child: Text(user.name,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Card(
                          color: fromCurrent ? Colors.red : Colors.white,
                          child: ListTile(
                            title: Text(message.message),
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            thickness: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Message...',
                      ),
                      onChanged: (val){
                        setState(() {
                          messageInput = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: messageInput.isEmpty ? null : (){
                  setState(() {
                    _formKey.currentState.reset();
                    thread.sendMessage(messageInput);
                  });
                },
              )
            ],
          ),
        ],
      )
    );
  }

  Future<bool> _showLeaveDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to leave this conversation?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Leave'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

