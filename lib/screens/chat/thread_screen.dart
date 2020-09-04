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
  String messageInput = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('init thread');
    widget.thread.listener = () => setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThreadModel thread = widget.thread;
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.threadID),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: thread.messages.length,
              itemBuilder: (context, index){
                MessageModel message = thread.messages[index];
                return Card(
                  child: ListTile(
                    title: Text(message.message),
                  )
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
                        messageInput = val;
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: (){
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
}