import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:path/path.dart";
import "dart:io";

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  String _uploadedFileURL;
  Future<FirebaseUser> _user = FirebaseAuth.instance.currentUser();

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FirebaseUser firebaseUser = snapshot.data;
              return Builder(
                builder: (context) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      : FadeInImage.assetNetwork(
                                          placeholder: "assets/images/profile.png",
                                          image: firebaseUser.photoUrl,
                                          fit: BoxFit.cover,
                                        ),
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
                                        uploadImage(context);
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
                      )
                    ],
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
