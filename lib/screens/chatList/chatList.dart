import 'package:flutter/material.dart';
import 'chatListTile.dart';
import 'package:simplechat/services/constants.dart';

class ChatList extends StatelessWidget {
  Stream chatRooms;

  ChatList(this.chatRooms);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatRooms,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ChatListTile(
                      userName: snapshot
                          .data.documents[index].data['chatRoomId']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId:
                          snapshot.data.documents[index].data["chatRoomId"],
                    );
                  })
              : Container();
        });
  }
}
