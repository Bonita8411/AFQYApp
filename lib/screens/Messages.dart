import "package:flutter/material.dart";
import 'dart:math';

class Messages extends StatelessWidget {

  List<String> starters = [
    "How was your weekend?",
    "Favourite food place?",
    "Do you have kids?",
    "Any plans this weekend?"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
              child:Builder(
                  builder: (context) => FloatingActionButton(
                      onPressed: () {
                        var random = Random();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Say: " +starters[random.nextInt(starters.length)]))
                        );
                      },
                      backgroundColor: Colors.red[900],
                      child: Icon(
                        Icons.autorenew,
                        color: Colors.white,
                      )
                  )
              )
              )
        ],
      )
    );
  }
}