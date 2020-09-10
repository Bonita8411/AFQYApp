import 'package:afqyapp/services/profile_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:path/path.dart";
import "dart:io";

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _getBio = "";
  String _bioString = "";
  File _image;
  String _uploadedFileURL;
  Future<FirebaseUser> _user = FirebaseAuth.instance.currentUser();

  Future getImage() async {
    await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 25).then((image) {
      setState(() {
        _image = File(image.path);
        print('Image Path $_image');
      });
    });
  }

  Future uploadImage(BuildContext context) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String fileName = basename(_image.path);
    print('fileName: ' + fileName);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('profiles/' + currentUser.uid);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        print("Profile Picture uploaded");
        print('uploaded file: ' + fileURL);

        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.photoUrl = fileURL;
        currentUser.updateProfile(userUpdateInfo);

        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Profile Picture Uploaded')));
      });
    });
  }



 Future<String> createAlertDialog(BuildContext context) async{
    TextEditingController myController = TextEditingController();
    return showDialog(context: context,builder: (context){
      return AlertDialog (
        title: Text("Enter Your Bio"),
        content: TextField(
          controller: myController,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Submit'),
                onPressed: () {
                  print(myController.text);
                  Navigator.of(context).pop(myController.text.toString());
                },
              )
            ],
          )
        ]
      );
      });
    }

Future saveBio(String bio) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('users').document(user.uid).setData(
      {
        "bio":bio,
      },
      merge: true,
    );
}
Future getBio() async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  Firestore.instance.collection('users').document(user.uid).get().then((result){
    setState(() {
      _bioString = result.data == null ? '' : result.data['bio'];
    });
  });
}
  @override
  void initState () {
      super.initState();
      getBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FirebaseUser firebaseUser = snapshot.data;
              print(firebaseUser.uid);
              return Builder(
                builder: (context) => Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.red[900],
                                child: ClipOval(
                                  child: new SizedBox(
                                    width: 180.0,
                                    height: 180.0,
                                    child: (_image != null)
                                        ? Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                          )
                                        : firebaseUser.photoUrl != null ?
                                    CachedNetworkImage(
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      imageUrl: firebaseUser.photoUrl,
                                      fit: BoxFit.cover,
                                    ) :
                                        Image.asset('assets/images/profile.png')
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.photo,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          getImage();
                                        },
                                      ),
                                      Text('Choose')
                                    ],
                                  ),
                                SizedBox(width: 15.0),
                                Column(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.cloud_upload,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          ProfileService.updateProfilePicture(_image).then((value) {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(content: Text('Your profile picture has been updated')));
                                          }).catchError(() {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(content: Text('An error has occured. Your profile picture has not been updated')));
                                          });
                                        },
                                      ),
                                      Text('Upload')
                                    ],
                                ),
                              ],
                            ),
                            SizedBox(width: 10.0,),

                        SizedBox(height: 25.0),
                        Text(
                          firebaseUser.displayName,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 10.0),
                        OutlineButton(
                            child: Text('Edit Bio'),
                            onPressed: () {
                              createAlertDialog(context).then((onValue){
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Your Bio has been updated')));
                                setState(() {
                                  if(onValue != null){
                                    _bioString = onValue;
                                    ProfileService.updateBio(onValue);
                                  }
                                });
                              });
                              },
                            ),
                        SizedBox(height: 10.0),
                        Text(
                          _bioString != null ? _bioString : '',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading profile'));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

