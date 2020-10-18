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
  TextEditingController _txtcontroller;
  List<UserProfile> _attendees = [];

  @override
  void initState() {
    _txtcontroller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserProfile> result = _attendees.length != 0 || _txtcontroller.text.isNotEmpty ? _attendees : [];
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
                      hintText: 'Search',
                      labelText: 'Name *',
                    ),
                    onChanged: onSearchTextChanged,
                    // onChanged: (val) => searchName = val,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _txtcontroller.clear();
                    onSearchTextChanged('');
                    // result = MessageService.instance.userSearch(searchName);
                    // setState(() {
                    // });
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

  onSearchTextChanged(String text) async {
    _attendees.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }
    List<UserProfile> users = MessageService.instance.userSearch();
    users.forEach((attendee) {
      bool isAlreadyAdded = false;
      if(attendee.name.toLowerCase().contains(text.toLowerCase())) {
        _attendees.add(attendee);
        isAlreadyAdded = true;
      }
    });
    setState(() {});
  }
}
