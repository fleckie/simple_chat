import 'package:flutter/material.dart';
import 'package:simplechat/services/chatHelper.dart';

Widget resultTile(String userName,String userEmail, BuildContext context){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),
            )
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: (){
            enterChat(userName, context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24)
            ),
            child: Text("Message",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),
          ),
        )
      ],
    ),
  );
}




