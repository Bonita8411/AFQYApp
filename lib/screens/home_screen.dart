import 'package:afqyapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("AFQY App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Home Screen"),
            SizedBox(height: 10.0),
            Text("User ID: " + AuthService.currentUser.uid),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text("Logout"),
              onPressed: () {
                AuthService.signOut().catchError((error) {
                  print(error);
                });
              },
            )
          ]
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.red[900],
          textTheme: Theme.of(context).textTheme.copyWith(caption: new TextStyle(color:Colors.grey[600]))),
        child:       BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                title: Text('Event')
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
