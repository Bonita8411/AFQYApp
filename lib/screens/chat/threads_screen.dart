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
    if(MessageService.instance.currentUser == null){
      FirebaseAuth.instance.currentUser().then((value) {
        MessageService.instance.currentUser = new UserProfile(value.uid, '', '', '');
        MessageService.instance.listener = () => setState(() {});
        MessageService.instance.loadThreads();
        setState(() {

        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ThreadModel> threads = MessageService.instance.threads;
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){

        },
      ),
      body: MessageService.instance.currentUser == null ? Center(child: CircularProgressIndicator(),)
          : ListView.builder(
            itemCount: threads.length,
            itemBuilder: (context, index){
              ThreadModel thread = threads[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThreadScreen(thread)),
                  );
                  },
                  title: Text(thread.threadID),
                  subtitle: Text(thread.lastMessage),
                ),);
            }
          )
    );
  }
}