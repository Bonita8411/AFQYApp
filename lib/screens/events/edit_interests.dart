import 'package:afqyapp/models/Eventbrite_event.dart';
import 'package:flutter/material.dart';

class EditInterestsScreen extends StatefulWidget {
  final EventbriteEvent event;
  EditInterestsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EditInterestsScreenState createState() => _EditInterestsScreenState();
}

class Interest {
  String interest;

  Interest(this.interest);

  static List<Interest> getInterests(){
    return <Interest>[
      Interest('Cooking'),
      Interest('Baking'),
      Interest('Eating'),
    ];
  }
}

class _EditInterestsScreenState extends State<EditInterestsScreen> {

  List<Interest> interest = Interest.getInterests();
  List<DropdownMenuItem<Interest>> dropdownMenuItems;
  Interest selectedInterest;

  @override
  void initState(){
    dropdownMenuItems = buildDropdownMenuItems(interest);
    selectedInterest = dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Interest>> buildDropdownMenuItems(List interest){
    List<DropdownMenuItem<Interest>> items = List();
    for (Interest int in interest){
      items.add(
        DropdownMenuItem(
          value: int,
          child: Text(int.interest),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Interest selected){
    setState(() {
      selectedInterest = selected;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Interests"),
        backgroundColor: Colors.red[900],
      ),
      body: new Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Select an interest that best describes you"),
              SizedBox(height: 20.0,),
              DropdownButton(
                value: selectedInterest,
                items: dropdownMenuItems,
                onChanged: onChangeDropdownItem,
              ),
              SizedBox(height: 20.0,),
              Text('Chosen: ${selectedInterest.interest}'),
            ],
          )
      )
      )
    );
  }
}
