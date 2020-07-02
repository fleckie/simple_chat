import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messageTile.dart';
import 'package:simplechat/services/constants.dart';
import 'pictureTile.dart';

Widget messageList (Stream<QuerySnapshot> chats){
  return StreamBuilder(
    stream: chats,
    builder: (context, snapshot){
      return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return
              snapshot.data.documents[index].data["url"] == null ?
              MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              ):
              PictureTile(
                  url: snapshot.data.documents[index].data["url"],
                  sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"]
              );
          }) : Container();
    },
  );
}

/*


*/
