import 'package:flutter/material.dart';
import 'chatList.dart';
import 'package:simplechat/services/constants.dart';
import 'package:simplechat/services/sharedPreferencesHelper.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'package:simplechat/services/auth.dart';
import 'package:simplechat/screens/authentication/authenticate.dart';
import 'package:simplechat/screens/search/searchScreen.dart';
import 'package:simplechat/screens/profil/profilePage.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream chatList;

  @override
  void initState() {
    getUserState();
    super.initState();
  }

  //Loads the User´s set name and their chats
  getUserState() async {
    Constants.myName = await SharedPreferencesHelper.getActiveUserName();
    FirestoreHelper().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatList = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.myName),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage(Constants.myName)));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.account_box))),
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: ChatList(chatList),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}
