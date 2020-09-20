import 'package:afqyapp/models/event_model.dart';
import 'package:flutter/material.dart';

class EditInterestsScreen extends StatefulWidget {
  final EventModel event;
  EditInterestsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {
  static List<String> interests = [
    '', //Empty String for if people don't want to choose an interest
    'Adventure',
    'API',
    'Baking',
    'Ballet',
    'Blockchain',
    'Cloud',
    'Cooking',
    'Development',
    'Eating',
    'Fishing',
    'Football',
    'Gaming',
    'MBaaS',
    'Mobile Apps',
    'PaaS',
    'Rugby',
    'Running',
    'SaaS',
    'Serverless',
    'Snorkelling',
    'Sports',
  ];

  List<DropdownMenuItem<String>> dropdownMenuItems = interests.map((interest) {
    return DropdownMenuItem<String>(
      child: Text(interest),
      value: interest,
    );
  }).toList();

  bool loading = false;
  List selectedInterests = [];

  Widget build(BuildContext context) {
    selectedInterests = widget.event.currentAttendee.interests;
    while (selectedInterests.length < 3) {
      selectedInterests.add('');
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Interests"),
          backgroundColor: Colors.red[900],
        ),
        body: Builder(
          builder: (context) => Center(
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Please choose up to three interests that you would like to display.'),
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
                        loading = true;
                      });
                      widget.event
                          .updateInterests(selectedInterests)
                          .then((value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Your interests have been saved as; ${selectedInterests.join(", ")}'),
                        ));
                      }).catchError((error) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to save interests.'),
                        ));
                      }).whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  )
                ],
              ),
              loading ? Center(child: CircularProgressIndicator()) : Container(),
            ]),
          ),
        ));
  }
}
