import 'package:flutter/material.dart';

class VerifyInstruction extends StatefulWidget {
  @override
  _VerifyInstruction createState() => _VerifyInstruction();
}

class _VerifyInstruction extends State<VerifyInstruction> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Did you just purchase a ticket?"),
      content: new Text(
          "\nStep 1: Go to Who's Going Tab \n\nStep 2: Click on Verify Ticket button \n\nStep 3: Scan the QR code on your ticket \n\nStep 4: You can edit your interests after verifying your ticket "),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
