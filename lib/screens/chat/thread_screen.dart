import 'package:afqyapp/models/message_model.dart';
import 'package:afqyapp/models/thread_model.dart';
import 'package:flutter/material.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadModel thread;

  ThreadScreen(this.thread);

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> { 
  @override
  void initState() {
    widget.thread.listener = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThreadModel thread = widget.thread;
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: thread.messages.length,
        itemBuilder: (context, index){
          MessageModel message = thread.messages[index];
          return Card(
            child: ListTile(
              title: Text(message.message),
            )
          );
        },
      )
    );
  }
}