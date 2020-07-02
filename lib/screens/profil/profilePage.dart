import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simplechat/services/constants.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
  final String userName;
  ProfilePage(this.userName);
}

class _ProfilePageState extends State<ProfilePage> {
  String status;
  String _uploadedFileURL;
  File _image;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isPersonalProfile;
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: status);
    checkIfPersonalProfile();
    loadStatusAndProfilePic();

  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
      _isEditing = false;
    });
    FirestoreHelper().updateBio(widget.userName, status);
  }

  Future loadStatusAndProfilePic() async {
    FirestoreHelper().searchByName(widget.userName).then((snapshot) {
      setState(() {
        status = snapshot.documents[0].data['status'];
        status == null ? status = "Enter your status here..." : status = status;
        _uploadedFileURL = snapshot.documents[0].data['url'];
        _isLoading = false;
      });
    });
  }



  checkIfPersonalProfile() {
    setState(() {
      _isPersonalProfile = widget.userName == Constants.myName ? true : false;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
    uploadPic();
  }

  Future uploadPic() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        print("file uploaded");
        _uploadedFileURL = fileURL;
      });
      FirestoreHelper().updateProfilePicURL(widget.userName, _uploadedFileURL);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            width: 350.0,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                _isLoading
                    ? CircularProgressIndicator()
                    : _isEditing
                        ? Center(
                            child: TextField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                autofocus: true,
                                controller: _editingController,
                                cursorColor: Colors.white,
                                onSubmitted: (newValue) {
                                  updateStatus(newValue);
                                }))
                        : InkWell(
                            onTap: () {
                              if (_isPersonalProfile) {
                                setState(() {
                                  _isEditing = true;
                                });
                              }
                            },
                            child: Text(
                              status,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white),
                            )),
                SizedBox(height: 60.0),
                GestureDetector(
                    onTap: () {
                      if (_isPersonalProfile) {
                        getImage();
                      }
                    },
                    child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: _uploadedFileURL == null
                                    ? AssetImage("assets/images/profile.webp")
                                    : NetworkImage(_uploadedFileURL),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ]))),
                SizedBox(height: 15.0),
                Text(
                  widget.userName,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.white),
                ),
              ],
            ))));
  }
}
