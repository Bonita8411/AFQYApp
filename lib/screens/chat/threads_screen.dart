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
      thread.viewStateListener = () => {};
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageService.instance.threads.forEach((thread) {
      thread.viewStateListener = () => setState((){});
    });
    List<ThreadModel> threads = MessageService.instance.threads;
    
    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.edit),
//        onPressed: (){
//
//        },
//      ),
      body: ListView.builder(
            itemCount: threads.length,
            itemBuilder: (context, index){
              ThreadModel thread = threads[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThreadScreen(thread)),
                  ).then((value) {
                    setState(() {

                    });
                    });
                  },
                  title: Text(thread.participantsToString()),
                  subtitle: Text(thread.lastMessage),
                ),);
            }
          )
    );
  }
}