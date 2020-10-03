import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/screens/Messages.dart';
import 'package:afqyapp/screens/chat/thread_screen.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThreadsScreen extends StatefulWidget {
  @override
  _ThreadsScreenState createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    MessageService.instance.threads.forEach((thread) {
      thread.threadsStateListener = () => {};
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageService.instance.threads.forEach((thread) {
      thread.threadsStateListener = () => setState((){});
    });
    List<ThreadModel> threads = MessageService.instance.threads;

    if(threads.length == 0) {
      Future.delayed(Duration(seconds: 3)).then((value) => setState((){}));
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.edit),
            label: Text('New Message'),
            onPressed: () {
              MessageService.instance.newThread([]).then((thread) {
                print('then');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThreadScreen(thread))).then((
                    value) => setState(() {}));
              });
            },
          ),
          body: ListView.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) {
                ThreadModel thread = threads[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThreadScreen(thread)),
                      ).then((value) {
                        setState(() {

                        });
                      });
                    },
                    title: thread.participants.length > 1
                        ? Text(thread.participantsToString(),
                        style: TextStyle(
                        fontWeight: thread.isRead ? FontWeight.normal : FontWeight.bold
                    ),
                    )
                        : Text('User left',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    subtitle: Text(
                      thread.lastMessage, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: thread.isRead ? FontWeight.normal : FontWeight.bold
                      ),),
                  ),);
              }
          )
      );
    }
  }
}