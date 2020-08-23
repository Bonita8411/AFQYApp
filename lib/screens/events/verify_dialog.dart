import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:afqyapp/models/event_model.dart';
import 'package:afqyapp/screens/events/edit_interests.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

class VerifyDialog extends StatefulWidget {
  final EventModel event;
  VerifyDialog({Key key, @required this.event}) : super(key: key);

  @override
  _VerifyDialogState createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<VerifyDialog> {
  String _ticketNumber = '';
  String _error = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ticket not verified'),
      content: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('To display your interests, please enter your ticket number.'),
                SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      _ticketNumber = val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Ticket number",
                    hintText: '12345678909876543210123',
                  ),
                ),
                SizedBox(height: 20.0,),
                Center(child: Text(_error,
                  style: TextStyle(color: Colors.red),
                ),),
              ],
            ),
          ),
          _loading ? Center(child: CircularProgressIndicator()) : SizedBox(height: 0.0),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Scan QR Code"),
          onPressed: () async {
            var result = await BarcodeScanner.scan();
            if(result.type.name == "Barcode"){
              print(result.rawContent);
              setState(() {
                _ticketNumber = result.rawContent;
              });
              _verify();
            }
          },
        ),
        FlatButton(
          child: Text('Verify'),
          onPressed: () {
            _verify();
          },
        ),
      ],
    );
  }

  void _verify() async {
    setState(() {
      _loading = true;
    });
    await widget.event.verifyTicket(_ticketNumber).then((verified){
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditInterestsScreen(event: widget.event),
          ));
    }).catchError((error){
      setState(() {
        _error = error;
      });
    });
    setState(() {
      _loading = false;
    });
  }
}
