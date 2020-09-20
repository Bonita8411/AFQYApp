import 'package:afqyapp/models/thread_model.dart';
import 'package:afqyapp/models/user_profile.dart';
import 'package:afqyapp/services/message_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  final ThreadModel thread;

  AddUserScreen(this.thread);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String searchName;
  List<UserProfile> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Case sensitive',
                      labelText: 'Name *',
                    ),
                    onChanged: (val) => searchName = val,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    result = await MessageService.instance.userSearch(searchName);
                    setState(() {

                    });
                  },
                )
              ],
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index){
                  UserProfile user = result[index];
                  bool disabled = widget.thread.participants.indexWhere((element) => element.uid == user.uid) != -1;
                  return ListTile(
                    enabled: !disabled,
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
                    trailing: IconButton(
                      icon: disabled ? Icon(Icons.check) : Icon(Icons.add),
                      onPressed: disabled ? null :  () async {
                        await widget.thread.addUsers([user.uid]);
                        setState(() {
                          disabled = true;
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
