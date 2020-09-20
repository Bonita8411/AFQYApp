import 'package:afqyapp/screens/chat/threads_screen.dart';
import 'package:afqyapp/services/auth_service.dart';
import "package:flutter/material.dart";
import 'Home.dart';
import 'events/Event.dart';
import 'Messages.dart';
import 'Profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{
  int _currentIndex = 0;
  final _pageOptions = [
    Home(),
    Event(),
    ThreadsScreen(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("AFQY App"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (index) {
              switch(index){
                case 'Logout':
                  AuthService.signOut();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.red[900],
          textTheme: Theme.of(context).textTheme.copyWith(caption: new TextStyle(color:Colors.grey[600]))),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                title: Text('Events')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile')
            )
          ],
          onTap: (index) {
            setState((){
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
