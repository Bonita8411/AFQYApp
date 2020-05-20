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

class _ProfileState extends State <Profile> {
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image){
        setState(() {
          _image = image;
          print('Image Path $_image');
        });
      });
    }

    Future uploadImage(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        print("Profile Picture uploaded");
        _uploadedFileURL = fileURL;
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    });
  }
    return Scaffold(
        body: Builder(
          builder: (context)=> Container (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child:CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.red[900],
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image!= null)?
                            Image.file(_image,
                              fit:BoxFit.none,
                            ): Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRou7yE3EGHGj-sIHZ4jW7E0APXe2WRDVFeOs00mA_97tk32rzq&usqp=CAU",
                            fit:BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          size: 30.0,
                        ),
                        onPressed: (){
                          getImage();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.upload,
                          size: 30.0,
                        ),
                        onPressed: (){
                          uploadImage(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}