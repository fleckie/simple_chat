import 'package:simplechat/services/constants.dart';
import 'package:simplechat/themes/textStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'messageList.dart';
import 'package:simplechat/screens/profil/profilePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ChatScreen({this.chatRoomId, this.userName});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageController = new TextEditingController();
  File _image;


  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      FirestoreHelper().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  addPicture() async {
      var image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 85);
      setState(() {
        _image = File(image.path);
        print('Image Path $_image');
      });
      uploadPic();
    }

  uploadPic() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    print("file uploaded");
    firebaseStorageRef.getDownloadURL().then((fileURL) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": "",
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        'url': fileURL
      };
      FirestoreHelper().addPictureMessage(widget.chatRoomId, chatMessageMap);
    });
  }



  @override
  void initState() {
    FirestoreHelper().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage(widget.userName)));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.account_box))),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            messageList(chats),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                GestureDetector(
                    onTap: () {
                     addPicture();
                    },
                    child: Icon(Icons.photo_camera)),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Icon(Icons.send)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

