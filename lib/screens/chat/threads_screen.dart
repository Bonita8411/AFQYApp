import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/screens/chat/thread_screen.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:flutter/material.dart';

class ThreadsScreen extends StatefulWidget {
  @override
  _ThreadsScreenState createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  
  @override
  void initState() {
    MessageService.instance.listener = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ThreadModel> threads = MessageService.instance.threads;
    
    return Scaffold(
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