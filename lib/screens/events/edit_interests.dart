import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:flutter/material.dart';

class EditInterestsScreen extends StatefulWidget {
  final EventbriteEvent event;
  EditInterestsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  static List<String> interests = [
    '',//Empty String for if people don't want to choose an interest
    'Cooking',
    'Baking',
    'Eating',
  ];

  List<DropdownMenuItem<String>> dropdownMenuItems = interests.map((interest) {
    return DropdownMenuItem<String>(
      child: Text(interest),
      value: interest,
    );
  }).toList();

  Future<List> selectedInterestsFuture;

  @override
  void initState(){
    super.initState();
    selectedInterestsFuture = widget.event.retrieveInterests();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Interests"),
        backgroundColor: Colors.red[900],
      ),
      body: FutureBuilder(
        future: selectedInterestsFuture,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List selectedInterests = snapshot.data;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Please choose up to three interests that you would like to display.'),
                  SizedBox(height: 20.0),
                  DropdownButton(
                    value: selectedInterests[0],
                    items: dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        selectedInterests[0] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButton(
                    value: selectedInterests[1],
                    items: dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        selectedInterests[1] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButton(
                    value: selectedInterests[2],
                    items: dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        selectedInterests[2] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text('Update Interests'),
                    onPressed: () {
                      setState(() {
                        selectedInterestsFuture = widget.event.updateInterests(selectedInterests);
                      });
                    },
                  )
                ],
              ),
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
            return Center(child: Text('Error'));
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
