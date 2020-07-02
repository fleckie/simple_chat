import 'package:flutter/material.dart';
import 'firestoreHelper.dart';
import 'constants.dart';
import 'package:simplechat/screens/chat/chatScreen.dart';

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

enterChat(String userName, BuildContext context) {
  List<String> users = [Constants.myName, userName];
  FirestoreHelper firestoreHelper = FirestoreHelper();

  String chatRoomId = getChatRoomId(Constants.myName, userName);

  Map<String, dynamic> chatRoom = {
    "users": users,
    "chatRoomId": chatRoomId,
  };

  firestoreHelper.addChatRoom(chatRoom, chatRoomId);

  Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          ChatScreen(
            chatRoomId: chatRoomId,
            userName: userName
          )
  ));
}